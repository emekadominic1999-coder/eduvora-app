import 'package:flutter/foundation.dart';

/// One short-video-sized idea pulled out of a course topic.
///
/// A topic transcribed straight from a real course description often bundles
/// several ideas behind semicolons ("Set theory; Venn diagrams; real
/// numbers") — exactly the shape of a 40-minute lecture, not a video anyone
/// finishes on their phone between classes. [VideoClipSplitter] breaks each
/// topic back down into the single ideas it was made of, so every clip below
/// maps to one short recording: one idea, one example, done.
@immutable
class VideoClip {
  const VideoClip({
    required this.text,
    required this.topicIndex,
    required this.clipIndex,
  });

  final String text;
  final int topicIndex;
  final int clipIndex;

  /// Stable identity for this clip within one course's topic list — used as
  /// the local "filmed" checklist key.
  String key(String department, String courseCode) =>
      '$department::$courseCode::$topicIndex::$clipIndex';
}

class VideoClipSplitter {
  const VideoClipSplitter._();

  static const int _maxClipLength = 115;

  static final RegExp _semicolon = RegExp(r';\s*');
  static final RegExp _sentenceBreak = RegExp(r'(?<=[a-z0-9%)])\.\s+(?=[A-Z])');
  static final RegExp _trailingStop = RegExp(r'\.$');

  /// Every clip a course's real topic list breaks down into, in the order
  /// they were taught.
  static List<VideoClip> clipsForTopics(List<String> topics) {
    final List<VideoClip> clips = <VideoClip>[];
    for (int topicIndex = 0; topicIndex < topics.length; topicIndex++) {
      final List<String> pieces = _splitTopic(topics[topicIndex]);
      for (int clipIndex = 0; clipIndex < pieces.length; clipIndex++) {
        clips.add(
          VideoClip(
            text: pieces[clipIndex],
            topicIndex: topicIndex,
            clipIndex: clipIndex,
          ),
        );
      }
    }
    return clips;
  }

  static List<String> _splitTopic(String topic) {
    final String text = topic.trim();
    final List<String> pieces = text
        .split(_semicolon)
        .map((String s) => s.trim())
        .where((String s) => s.isNotEmpty)
        .toList();

    final List<String> clips = <String>[];
    for (final String piece in pieces) {
      if (piece.length <= _maxClipLength) {
        clips.add(piece);
        continue;
      }
      final List<String> sentences = piece
          .split(_sentenceBreak)
          .map((String s) => s.trim().replaceAll(_trailingStop, ''))
          .where((String s) => s.isNotEmpty)
          .toList();
      if (sentences.length > 1) {
        clips.addAll(sentences);
      } else {
        clips.add(piece);
      }
    }
    return clips.isEmpty ? <String>[text] : clips;
  }
}
