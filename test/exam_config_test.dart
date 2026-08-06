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

  group('Custom question ceiling', () {
    test('a custom paper may be asked for up to a hundred questions', () {
      expect(CbtExamConfig.maxCustomQuestions, 100);
    });

    test('a large bank can fill a hundred-question paper', () {
      final CbtSubject subject = _subject(count: 250);
      const CbtExamConfig config = CbtExamConfig(
        questionCount: 100,
        minutes: 120,
        isCustom: true,
      );

      expect(config.buildPaper(subject, seed: 1).length, 100);
    });

    test('asking for more than the bank holds hands back what exists', () {
      // The sheet caps the stepper, but buildPaper is the last line of
      // defence — it must never invent questions to reach a number.
      final CbtSubject subject = _subject(count: 12);
      const CbtExamConfig config = CbtExamConfig(
        questionCount: 100,
        minutes: 60,
        isCustom: true,
      );

      expect(config.buildPaper(subject, seed: 1).length, 12);
    });

    test('a hundred-question paper draws no duplicates', () {
      final CbtSubject subject = _subject(count: 140);
      const CbtExamConfig config = CbtExamConfig(
        questionCount: 100,
        minutes: 120,
        shuffleQuestions: true,
        isCustom: true,
      );

      final List<CbtQuestion> paper = config.buildPaper(subject, seed: 7);
      expect(paper.map((CbtQuestion q) => q.id).toSet().length, 100);
    });
  });

  group('Marks out of 70', () {
    CbtAttempt attempt({required int score, required int total}) => CbtAttempt(
      subjectId: 'test',
      subjectName: 'Test paper',
      totalQuestions: total,
      answers: const <String, int>{},
      score: score,
      durationSeconds: 600,
      takenAt: DateTime(2026, 8, 6),
    );

    test('a university examination is marked out of 70, not 100', () {
      expect(CbtExamConfig.totalMarks, 70);
      expect(CbtAttempt.totalMarks, 70);
    });

    test('every question right is full marks', () {
      expect(attempt(score: 40, total: 40).marksAwarded, 70);
    });

    test('nothing right is nought', () {
      expect(attempt(score: 0, total: 40).marksAwarded, 0);
    });

    test('half the paper is half the marks', () {
      expect(attempt(score: 20, total: 40).marksAwarded, 35);
    });

    test('30 out of 40 scales to 53', () {
      // (30 / 40) * 70 = 52.5, which rounds to 53.
      expect(attempt(score: 30, total: 40).marks, closeTo(52.5, 0.001));
      expect(attempt(score: 30, total: 40).marksAwarded, 53);
    });

    test('the mark scales with the paper, not its length', () {
      // Seven out of ten and seventy out of a hundred are the same result.
      expect(
        attempt(score: 7, total: 10).marksAwarded,
        attempt(score: 70, total: 100).marksAwarded,
      );
    });

    test('an empty paper does not divide by zero', () {
      expect(attempt(score: 0, total: 0).marks, 0);
      expect(attempt(score: 0, total: 0).marksAwarded, 0);
    });

    test('the percentage is unchanged by the new marking', () {
      // Grades are still percentage-based, so this must not drift.
      expect(attempt(score: 30, total: 40).percentage, 75);
      expect(attempt(score: 30, total: 40).grade, 'A');
    });

    test('a mark never exceeds the total on offer', () {
      for (int total = 1; total <= 100; total++) {
        expect(
          attempt(score: total, total: total).marksAwarded,
          lessThanOrEqualTo(CbtAttempt.totalMarks),
        );
      }
    });
  });
}
