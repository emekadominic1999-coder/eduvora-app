import 'dart:typed_data';

import 'package:eduvora/core/utils/wav_encoder.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reads the fields of a canonical 44-byte WAV header back out, so a test can
/// assert on what a player would actually be told about the audio.
class _Header {
  _Header(Uint8List wav)
    : riff = String.fromCharCodes(wav.sublist(0, 4)),
      wave = String.fromCharCodes(wav.sublist(8, 12)),
      audioFormat = ByteData.sublistView(wav).getUint16(20, Endian.little),
      channels = ByteData.sublistView(wav).getUint16(22, Endian.little),
      sampleRate = ByteData.sublistView(wav).getUint32(24, Endian.little),
      byteRate = ByteData.sublistView(wav).getUint32(28, Endian.little),
      blockAlign = ByteData.sublistView(wav).getUint16(32, Endian.little),
      bitsPerSample = ByteData.sublistView(wav).getUint16(34, Endian.little),
      dataSize = ByteData.sublistView(wav).getUint32(40, Endian.little);

  final String riff;
  final String wave;
  final int audioFormat;
  final int channels;
  final int sampleRate;
  final int byteRate;
  final int blockAlign;
  final int bitsPerSample;
  final int dataSize;
}

/// [seconds] of a simple tone at [rate], as mono PCM16.
Uint8List _tone(int rate, double seconds, {double hz = 440}) {
  final int samples = (rate * seconds).round();
  final Uint8List out = Uint8List(samples * 2);
  final ByteData view = ByteData.sublistView(out);
  for (int i = 0; i < samples; i++) {
    // A cheap triangle-ish wave; the exact shape does not matter, only that
    // it is non-silent and periodic.
    final double phase = (i * hz / rate) % 1.0;
    final double value = (phase < 0.5 ? phase * 4 - 1 : 3 - phase * 4);
    view.setInt16(i * 2, (value * 20000).round(), Endian.little);
  }
  return out;
}

void main() {
  group('WavEncoder', () {
    test('writes a structurally valid canonical WAV header', () {
      final EncodedVoiceNote note = WavEncoder.encode(
        _tone(16000, 1),
        sourceSampleRate: 16000,
      );
      final _Header h = _Header(note.bytes);

      expect(h.riff, 'RIFF');
      expect(h.wave, 'WAVE');
      expect(h.audioFormat, 1, reason: 'must be uncompressed PCM');
      expect(h.channels, 1);
      expect(h.bitsPerSample, 16);
      expect(h.blockAlign, h.channels * h.bitsPerSample ~/ 8);
      expect(h.byteRate, h.sampleRate * h.blockAlign);
      expect(h.dataSize, note.bytes.length - 44);
    });

    // The bug this file exists for: browsers ignore the requested rate and
    // capture at their AudioContext's rate instead. A header that repeats the
    // *requested* rate rather than the real one plays back at the wrong speed
    // and pitch — 48 kHz audio labelled 16 kHz is an unintelligible rumble.
    test('never labels audio with a rate it was not captured at', () {
      for (final int captured in <int>[16000, 22050, 44100, 48000]) {
        final EncodedVoiceNote note = WavEncoder.encode(
          _tone(captured, 1),
          sourceSampleRate: captured,
        );
        final _Header h = _Header(note.bytes);

        // One second in must stay one second out, whatever happens between.
        expect(
          note.duration.inMilliseconds,
          closeTo(1000, 20),
          reason: 'duration must survive encoding at ${captured}Hz',
        );
        // Whatever rate the header claims, the payload must genuinely be at
        // that rate — checked via the byte count the rate implies.
        final int impliedSamples = h.dataSize ~/ 2;
        expect(
          impliedSamples / h.sampleRate,
          closeTo(1.0, 0.02),
          reason: 'header rate ${h.sampleRate}Hz must match the real payload',
        );
        expect(h.sampleRate, note.sampleRate);
      }
    });

    test('downsamples to 16 kHz when the source is a whole multiple', () {
      final EncodedVoiceNote note = WavEncoder.encode(
        _tone(48000, 1),
        sourceSampleRate: 48000,
      );
      expect(note.sampleRate, 16000);
      // 48 kHz mono for a second is 96000 bytes; a third of that, plus header.
      expect(note.bytes.length - 44, 32000);
      expect(note.duration.inMilliseconds, closeTo(1000, 20));
    });

    test('leaves rates it cannot cleanly reduce alone', () {
      final EncodedVoiceNote note = WavEncoder.encode(
        _tone(44100, 1),
        sourceSampleRate: 44100,
      );
      // 44100 is not a whole multiple of 16000, so reducing it would need
      // real interpolation. Storing a bigger correct file beats a mangled one.
      expect(note.sampleRate, 44100);
      expect(note.duration.inMilliseconds, closeTo(1000, 20));
    });

    test('does not downsample stereo', () {
      final EncodedVoiceNote note = WavEncoder.encode(
        _tone(48000, 1),
        sourceSampleRate: 48000,
        channels: 2,
      );
      expect(note.sampleRate, 48000, reason: 'interleaving must not be split');
      expect(_Header(note.bytes).channels, 2);
    });

    test('downsampling preserves the signal rather than silencing it', () {
      final Uint8List pcm = _tone(48000, 1);
      final EncodedVoiceNote note = WavEncoder.encode(
        pcm,
        sourceSampleRate: 48000,
      );

      final ByteData out = ByteData.sublistView(note.bytes, 44);
      int peak = 0;
      for (int i = 0; i < (note.bytes.length - 44) ~/ 2; i++) {
        final int v = out.getInt16(i * 2, Endian.little).abs();
        if (v > peak) peak = v;
      }
      // A silent or destroyed result would sit near zero; the source peaks
      // around 20000, and averaging should keep it well within reach of that.
      expect(peak, greaterThan(10000));
    });

    test('handles an empty recording without throwing', () {
      final EncodedVoiceNote note = WavEncoder.encode(
        Uint8List(0),
        sourceSampleRate: 48000,
      );
      expect(note.bytes.length, 44);
      expect(note.duration, Duration.zero);
    });
  });
}
