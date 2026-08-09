import 'dart:typed_data';

/// A finished voice note: the WAV bytes, how long they play for, and the
/// sample rate actually written into the header.
class EncodedVoiceNote {
  const EncodedVoiceNote({
    required this.bytes,
    required this.duration,
    required this.sampleRate,
  });

  final Uint8List bytes;
  final Duration duration;
  final int sampleRate;
}

/// Wraps raw 16-bit PCM samples in a standard WAV header.
///
/// Voice notes are recorded with `record`'s `startStream`, which yields raw
/// PCM bytes rather than a finished audio file — the only capture mode that
/// behaves identically on every platform this app ships to, Flutter Web
/// included, where there is no filesystem to hand a recorder a path to write
/// into. A WAV file is nothing more than those same bytes with a 44-byte
/// header describing the format in front of them, so wrapping them here is
/// enough to get a file every platform's audio stack already knows how to
/// play, with no native codec involved.
///
/// The header must describe the rate the audio was *actually* captured at,
/// not the rate that was asked for. Browsers in particular ignore the
/// requested rate and hand back whatever their AudioContext runs at — 48 kHz,
/// usually — and a file whose header claims 16 kHz while holding 48 kHz audio
/// plays back three times too slowly, an octave and a half down: an
/// unintelligible rumble rather than a voice. The caller therefore passes the
/// effective rate reported by the recorder, and [encode] resamples down to
/// [preferredSampleRate] where it cleanly can.
class WavEncoder {
  const WavEncoder._();

  /// The rate requested from the recorder, and the rate notes are stored at
  /// when the captured audio can be cleanly reduced to it. Speech carries
  /// perfectly well at 16 kHz, and it keeps a two-minute note to roughly
  /// 3.5 MB rather than the ~11.5 MB the same note costs at 48 kHz — which
  /// matters a great deal on campus mobile data.
  static const int preferredSampleRate = 16000;
  static const int numChannels = 1;
  static const int bitsPerSample = 16;

  static const int _bytesPerSample = bitsPerSample ~/ 8;

  /// Packages raw PCM16 captured at [sourceSampleRate] into a playable WAV.
  static EncodedVoiceNote encode(
    Uint8List pcm, {
    required int sourceSampleRate,
    int channels = numChannels,
  }) {
    Uint8List samples = pcm;
    int rate = sourceSampleRate;

    // Only reduce when the source is an exact whole multiple of the target
    // and the audio is mono. Anything else is left at its captured rate:
    // a larger file is a far smaller problem than a mangled one.
    if (channels == 1 &&
        sourceSampleRate > preferredSampleRate &&
        sourceSampleRate % preferredSampleRate == 0) {
      final int factor = sourceSampleRate ~/ preferredSampleRate;
      samples = _downsampleMono(pcm, factor);
      rate = preferredSampleRate;
    }

    return EncodedVoiceNote(
      bytes: _wrap(samples, rate, channels),
      duration: durationOf(
        samples.lengthInBytes,
        sampleRate: rate,
        channels: channels,
      ),
      sampleRate: rate,
    );
  }

  /// Averages each run of [factor] samples into one. The averaging is what
  /// makes this safe: dropping samples outright would fold every frequency
  /// above the new limit back down into the audible range as aliasing, which
  /// on speech sounds like a metallic warble. A box average is a crude
  /// low-pass, but an adequate one at these ratios for voice.
  static Uint8List _downsampleMono(Uint8List pcm, int factor) {
    final ByteData src = ByteData.sublistView(pcm);
    final int inSamples = pcm.lengthInBytes ~/ _bytesPerSample;
    final int outSamples = inSamples ~/ factor;

    final Uint8List out = Uint8List(outSamples * _bytesPerSample);
    final ByteData dst = ByteData.sublistView(out);

    for (int i = 0; i < outSamples; i++) {
      int total = 0;
      for (int j = 0; j < factor; j++) {
        total += src.getInt16((i * factor + j) * _bytesPerSample, Endian.little);
      }
      int value = (total / factor).round();
      if (value > 32767) value = 32767;
      if (value < -32768) value = -32768;
      dst.setInt16(i * _bytesPerSample, value, Endian.little);
    }
    return out;
  }

  static Uint8List _wrap(Uint8List pcmBytes, int sampleRate, int channels) {
    final int byteRate = sampleRate * channels * _bytesPerSample;
    final int blockAlign = channels * _bytesPerSample;
    final int dataSize = pcmBytes.lengthInBytes;

    final ByteData header = ByteData(44);
    void writeString(int offset, String value) {
      for (int i = 0; i < value.length; i++) {
        header.setUint8(offset + i, value.codeUnitAt(i));
      }
    }

    writeString(0, 'RIFF');
    header.setUint32(4, 36 + dataSize, Endian.little);
    writeString(8, 'WAVE');
    writeString(12, 'fmt ');
    header.setUint32(16, 16, Endian.little); // fmt chunk size (PCM)
    header.setUint16(20, 1, Endian.little); // audio format: PCM
    header.setUint16(22, channels, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, byteRate, Endian.little);
    header.setUint16(32, blockAlign, Endian.little);
    header.setUint16(34, bitsPerSample, Endian.little);
    writeString(36, 'data');
    header.setUint32(40, dataSize, Endian.little);

    final Uint8List wav = Uint8List(44 + dataSize);
    wav.setRange(0, 44, header.buffer.asUint8List());
    wav.setRange(44, wav.length, pcmBytes);
    return wav;
  }

  /// How long a clip of [pcmByteCount] raw PCM16 bytes plays for.
  static Duration durationOf(
    int pcmByteCount, {
    required int sampleRate,
    int channels = numChannels,
  }) {
    final int byteRate = sampleRate * channels * _bytesPerSample;
    if (byteRate <= 0) return Duration.zero;
    return Duration(milliseconds: (pcmByteCount / byteRate * 1000).round());
  }
}
