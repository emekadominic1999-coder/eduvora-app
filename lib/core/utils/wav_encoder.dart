import 'dart:typed_data';

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
class WavEncoder {
  const WavEncoder._();

  /// Sample rate voice notes are recorded at. Speech carries perfectly well
  /// at 16 kHz, and it keeps a two-minute note under a megabyte.
  static const int sampleRate = 16000;
  static const int numChannels = 1;
  static const int bitsPerSample = 16;

  /// Builds a playable WAV file from accumulated PCM16 mono samples.
  static Uint8List wrapPcm16(Uint8List pcmBytes) {
    final int byteRate = sampleRate * numChannels * (bitsPerSample ~/ 8);
    final int blockAlign = numChannels * (bitsPerSample ~/ 8);
    final int dataSize = pcmBytes.lengthInBytes;
    final int chunkSize = 36 + dataSize;

    final ByteData header = ByteData(44);
    void writeString(int offset, String value) {
      for (int i = 0; i < value.length; i++) {
        header.setUint8(offset + i, value.codeUnitAt(i));
      }
    }

    writeString(0, 'RIFF');
    header.setUint32(4, chunkSize, Endian.little);
    writeString(8, 'WAVE');
    writeString(12, 'fmt ');
    header.setUint32(16, 16, Endian.little); // fmt chunk size (PCM)
    header.setUint16(20, 1, Endian.little); // audio format: PCM
    header.setUint16(22, numChannels, Endian.little);
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
  static Duration durationOf(int pcmByteCount) {
    final int byteRate = sampleRate * numChannels * (bitsPerSample ~/ 8);
    if (byteRate == 0) return Duration.zero;
    final double seconds = pcmByteCount / byteRate;
    return Duration(milliseconds: (seconds * 1000).round());
  }
}
