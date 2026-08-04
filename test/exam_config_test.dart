import 'dart:math';

import 'package:eduvora/core/models/cbt.dart';
import 'package:flutter_test/flutter_test.dart';

CbtQuestion _q(int n) => CbtQuestion(
  id: 'q$n',
  question: 'Question $n',
  options: <String>['A$n', 'B$n', 'C$n', 'D$n'],
  correctIndex: n % 4,
  explanation: 'Because $n',
);

CbtSubject _subject({int count = 10}) => CbtSubject(
  id: 'test',
  name: 'Test paper',
  description: '',
  questions: List<CbtQuestion>.generate(count, _q),
  minutesPerAttempt: 15,
);

void main() {
  group('Standard exam', () {
    test('uses the whole paper, in order, at the paper’s own duration', () {
      final CbtSubject subject = _subject();
      final CbtExamConfig config = CbtExamConfig.standard(subject);

      expect(config.questionCount, 10);
      expect(config.minutes, 15);
      expect(config.isCustom, isFalse);

      final List<CbtQuestion> paper = config.buildPaper(subject, seed: 1);
      expect(paper.length, 10);
      expect(
        paper.map((CbtQuestion q) => q.id).toList(),
        subject.questions.map((CbtQuestion q) => q.id).toList(),
        reason: 'standard must not reorder anything',
      );
    });
  });

  group('Custom exam', () {
    test('honours a shortened question count', () {
      final CbtSubject subject = _subject();
      const CbtExamConfig config = CbtExamConfig(
        questionCount: 4,
        minutes: 5,
        isCustom: true,
      );

      expect(config.buildPaper(subject, seed: 1).length, 4);
      expect(config.duration, const Duration(minutes: 5));
    });

    test('a count beyond the paper size is clamped, not an error', () {
      final CbtSubject subject = _subject(count: 6);
      const CbtExamConfig config = CbtExamConfig(
        questionCount: 500,
        minutes: 30,
        isCustom: true,
      );

      expect(config.buildPaper(subject, seed: 1).length, 6);
    });

    test('a zero or negative count still yields a sittable paper', () {
      final CbtSubject subject = _subject();
      const CbtExamConfig config = CbtExamConfig(
        questionCount: 0,
        minutes: 10,
        isCustom: true,
      );

      expect(config.buildPaper(subject, seed: 1).length, 1);
    });

    test('shuffling questions changes the order but keeps every question', () {
      final CbtSubject subject = _subject(count: 20);
      const CbtExamConfig config = CbtExamConfig(
        questionCount: 20,
        minutes: 20,
        shuffleQuestions: true,
        isCustom: true,
      );

      final List<CbtQuestion> paper = config.buildPaper(subject, seed: 7);
      expect(paper.length, 20);
      expect(
        paper.map((CbtQuestion q) => q.id).toSet(),
        subject.questions.map((CbtQuestion q) => q.id).toSet(),
        reason: 'no question may be lost or duplicated',
      );
    });
  });

  group('Option shuffling', () {
    test('the correct answer follows its option to the new position', () {
      final Random rng = Random(42);

      for (int i = 0; i < 50; i++) {
        final CbtQuestion original = _q(i);
        final String rightAnswer = original.correctOption;

        final CbtQuestion shuffled = original.withShuffledOptions(rng);

        expect(
          shuffled.correctOption,
          rightAnswer,
          reason: 'shuffling must never change which answer is right',
        );
        expect(shuffled.options.toSet(), original.options.toSet());
        expect(shuffled.id, original.id);
        expect(shuffled.explanation, original.explanation);
      }
    });

    test('option shuffling through buildPaper preserves correctness', () {
      final CbtSubject subject = _subject(count: 12);
      const CbtExamConfig config = CbtExamConfig(
        questionCount: 12,
        minutes: 12,
        shuffleQuestions: true,
        shuffleOptions: true,
        isCustom: true,
      );

      final List<CbtQuestion> paper = config.buildPaper(subject, seed: 3);

      for (final CbtQuestion sat in paper) {
        final CbtQuestion original = subject.questions.firstWhere(
          (CbtQuestion q) => q.id == sat.id,
        );
        expect(
          sat.correctOption,
          original.correctOption,
          reason: 'marking would silently break otherwise',
        );
        expect(sat.correctIndex, inInclusiveRange(0, sat.options.length - 1));
      }
    });
  });
}
