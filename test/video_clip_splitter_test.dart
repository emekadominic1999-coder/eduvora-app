import 'package:eduvora/core/utils/video_clip_splitter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VideoClipSplitter', () {
    test('splits a semicolon-bundled topic into separate short clips', () {
      // The real MTH 111 topic list transcribed this session — a known-good
      // case already verified against the JS port used in the planning tool.
      final List<String> topics = <String>[
        'Elementary sets Theory; Subsets, Union, Intersection, Complements. Venn diagrams',
        'Real Numbers, Integers, Rational and Irrational numbers',
        'Mathematical inductions, Real sequences and Series',
        'Theory of quadratic equation, Binomial Theorem',
        "Complex numbers, Algebra of complex numbers. The Argand diagram, De Moivre's Theorem, nth roots of Unity",
        'Circular measure, Trigonometric functions of angles of any magnitude, addition and factor formulae',
      ];

      final List<VideoClip> clips = VideoClipSplitter.clipsForTopics(topics);

      expect(clips.length, 7, reason: 'the semicolon in topic 0 should split into two clips');
      expect(clips[0].text, 'Elementary sets Theory');
      expect(clips[1].text, 'Subsets, Union, Intersection, Complements. Venn diagrams');
      expect(clips[2].text, 'Real Numbers, Integers, Rational and Irrational numbers');
      expect(clips[6].text, 'Circular measure, Trigonometric functions of angles of any magnitude, addition and factor formulae');
    });

    test('leaves a short single-idea topic alone', () {
      final List<VideoClip> clips = VideoClipSplitter.clipsForTopics(<String>[
        'Basic concepts, definitions and laws',
      ]);
      expect(clips.length, 1);
      expect(clips.single.text, 'Basic concepts, definitions and laws');
    });

    test('does not fragment a long topic that has no natural break', () {
      // No semicolon and no sentence-ending period+capital pattern — should
      // stay a single clip rather than being torn apart.
      final String longSingleIdea =
          'A moderately long description of one continuous idea without any semicolons or sentence-ending periods that could serve as a natural split point for shorter clips';
      final List<VideoClip> clips = VideoClipSplitter.clipsForTopics(<String>[
        longSingleIdea,
      ]);
      expect(clips.length, 1);
      expect(clips.single.text, longSingleIdea);
    });

    test('splits an overlong piece on sentence boundaries when no semicolon exists', () {
      final List<VideoClip> clips = VideoClipSplitter.clipsForTopics(<String>[
        'This is the first full sentence of a long topic string. This is the second full sentence that pushes it well past the short-clip length threshold.',
      ]);
      expect(clips.length, 2);
      expect(clips[0].text, 'This is the first full sentence of a long topic string');
      expect(
        clips[1].text,
        'This is the second full sentence that pushes it well past the short-clip length threshold',
      );
    });

    test('clip keys are unique and stable per topic/clip position', () {
      final List<VideoClip> clips = VideoClipSplitter.clipsForTopics(<String>[
        'First topic; Second half of first topic',
        'Second topic entirely',
      ]);
      final List<String> keys = clips
          .map((VideoClip c) => c.key('Mathematics', 'MTH 111'))
          .toList();
      expect(keys.toSet().length, keys.length, reason: 'keys must be unique');
      expect(keys[0], 'Mathematics::MTH 111::0::0');
      expect(keys[1], 'Mathematics::MTH 111::0::1');
      expect(keys[2], 'Mathematics::MTH 111::1::0');
    });

    test('handles an empty topic list without throwing', () {
      expect(VideoClipSplitter.clipsForTopics(const <String>[]), isEmpty);
    });
  });
}
