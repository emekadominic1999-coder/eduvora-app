import 'dart:math';

import 'package:flutter/foundation.dart';

/// A single multiple-choice item in the CBT bank.
@immutable
class CbtQuestion {
  const CbtQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation = '',
    this.topic = '',
  });

  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String topic;

  String get correctOption => correctIndex >= 0 && correctIndex < options.length
      ? options[correctIndex]
      : '';

  /// A, B, C, D … for the option at [index].
  static String letterFor(int index) => String.fromCharCode(65 + index);

  /// The same question with its options in a new order.
  ///
  /// [correctIndex] is remapped to follow the correct option to its new
  /// position — shuffling must never change which answer is right.
  CbtQuestion withShuffledOptions(Random rng) {
    final List<int> order = List<int>.generate(options.length, (int i) => i)
      ..shuffle(rng);

    return CbtQuestion(
      id: id,
      question: question,
      options: order.map((int i) => options[i]).toList(),
      correctIndex: order.indexOf(correctIndex),
      explanation: explanation,
      topic: topic,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'question': question,
    'options': options,
    'correct_index': correctIndex,
    'explanation': explanation,
    'topic': topic,
  };

  factory CbtQuestion.fromJson(Map<String, dynamic> json) => CbtQuestion(
    id: (json['id'] ?? '') as String,
    question: (json['question'] ?? '') as String,
    options: (json['options'] as List<dynamic>? ?? <dynamic>[])
        .map((dynamic e) => e.toString())
        .toList(),
    correctIndex: (json['correct_index'] as num?)?.toInt() ?? 0,
    explanation: (json['explanation'] ?? '') as String,
    topic: (json['topic'] ?? '') as String,
  );
}

/// A themed paper the student can sit — e.g. "Use of English", "Engineering
/// Mathematics", "General Physiology".
@immutable
class CbtSubject {
  const CbtSubject({
    required this.id,
    required this.name,
    required this.description,
    required this.questions,
    this.faculties = const <String>[],
    this.minutesPerAttempt = 15,
    this.isGeneralStudies = false,
    this.department = '',
    this.level = '',
    this.semester = '',
    this.units = 0,
  });

  final String id;
  final String name;
  final String description;
  final List<CbtQuestion> questions;

  /// Faculties this paper is aimed at; empty means every student.
  final List<String> faculties;
  final int minutesPerAttempt;
  final bool isGeneralStudies;

  /// The course this paper corresponds to — used by the course-pack picker
  /// to group papers by department, level and semester the way real course
  /// registration does.
  final String department;
  final String level;

  /// 'first' or 'second'.
  final String semester;

  /// Credit units of the underlying course, for the course pack's 23-unit
  /// registration cap. 0 when unknown.
  final int units;

  bool isRelevantTo(String faculty) =>
      isGeneralStudies || faculties.isEmpty || faculties.contains(faculty);
}

/// How a student has chosen to sit a paper.
///
/// **Standard** mirrors the real thing: every question, the paper's own
/// recommended duration, in the order it was written. **Custom** lets the
/// student shorten a paper for a quick revision run, give themselves more (or
/// less) time, and shuffle so repeated attempts are not memorised by position.
@immutable
class CbtExamConfig {
  const CbtExamConfig({
    required this.questionCount,
    required this.minutes,
    this.shuffleQuestions = false,
    this.shuffleOptions = false,
    this.isCustom = false,
  });

  /// A realistic single-sitting mock exam: [standardQuestionCount] questions
  /// drawn at random from the paper (or every question, if the paper holds
  /// fewer than that), in [standardMinutes] minutes.
  factory CbtExamConfig.standard(CbtSubject subject) => CbtExamConfig(
    questionCount: min(standardQuestionCount, subject.questions.length),
    minutes: standardMinutes,
    shuffleQuestions: true,
  );

  /// How many questions, and how much time, a standard sitting gives.
  static const int standardQuestionCount = 35;
  static const int standardMinutes = 60;

  /// The most questions a custom paper may ask for. A student revising wants
  /// a long paper available; beyond a hundred it stops being a sitting and
  /// starts being a marathon. Capped again by what the subject actually holds.
  static const int maxCustomQuestions = 100;

  /// What a paper is worth.
  ///
  /// Nigerian universities mark the examination out of 70, with the remaining
  /// 30 coming from continuous assessment. Scoring out of 70 is therefore the
  /// number a student can compare against their real result — a percentage
  /// alone tells them less than "49 out of 70" does.
  static const int totalMarks = 70;

  final int questionCount;
  final int minutes;
  final bool shuffleQuestions;
  final bool shuffleOptions;
  final bool isCustom;

  Duration get duration => Duration(minutes: minutes);

  /// Builds the working question list for an attempt, applying the count and
  /// any shuffling. [seed] keeps a given attempt reproducible for tests.
  ///
  /// A shortened paper (fewer questions than the subject holds) draws across
  /// every topic in the pool rather than a blind random sample of the whole
  /// bank — an exam is meant to touch every part of the course, not risk
  /// clustering by chance around whichever topics happen to be biggest.
  List<CbtQuestion> buildPaper(CbtSubject subject, {int? seed}) {
    final Random rng = Random(seed ?? DateTime.now().microsecondsSinceEpoch);
    final int take = questionCount.clamp(1, subject.questions.length);

    final List<CbtQuestion> paper = shuffleQuestions
        ? _stratifiedSample(subject.questions, take, rng)
        : subject.questions.take(take).toList();

    if (!shuffleOptions) return paper;
    return paper.map((CbtQuestion q) => q.withShuffledOptions(rng)).toList();
  }

  /// Groups [pool] by topic, shuffles each topic's own order, then draws in
  /// round-robin across topics (one from each, then a second from each that
  /// still has more, and so on) until [take] questions are selected — so a
  /// paper shorter than the full bank still spans every topic it can before
  /// any topic gets a second question. The final order is shuffled too, so
  /// the result doesn't read as one block per topic.
  static List<CbtQuestion> _stratifiedSample(
    List<CbtQuestion> pool,
    int take,
    Random rng,
  ) {
    if (take >= pool.length) {
      return (List<CbtQuestion>.from(pool)..shuffle(rng));
    }

    final Map<String, List<CbtQuestion>> byTopic = <String, List<CbtQuestion>>{};
    for (final CbtQuestion q in pool) {
      byTopic.putIfAbsent(q.topic, () => <CbtQuestion>[]).add(q);
    }
    final List<List<CbtQuestion>> groups = byTopic.values
        .map((List<CbtQuestion> g) => List<CbtQuestion>.from(g)..shuffle(rng))
        .toList()
      ..shuffle(rng);

    final List<CbtQuestion> selected = <CbtQuestion>[];
    int round = 0;
    while (selected.length < take) {
      final int before = selected.length;
      for (final List<CbtQuestion> group in groups) {
        if (selected.length >= take) break;
        if (round < group.length) selected.add(group[round]);
      }
      if (selected.length == before) break; // every group exhausted
      round++;
    }
    return selected..shuffle(rng);
  }
}

/// The student's answer sheet while an exam is in progress.
class CbtAttempt {
  CbtAttempt({
    required this.subjectId,
    required this.subjectName,
    required this.totalQuestions,
    required this.answers,
    required this.score,
    required this.durationSeconds,
    required this.takenAt,
  });

  final String subjectId;
  final String subjectName;
  final int totalQuestions;

  /// Question id → selected option index.
  final Map<String, int> answers;
  final int score;
  final int durationSeconds;
  final DateTime takenAt;

  double get percentage =>
      totalQuestions == 0 ? 0 : (score / totalQuestions) * 100;

  /// The paper scaled to the 70 marks a Nigerian university examination
  /// carries, so 30 correct out of 40 reads as 53 — the figure that will
  /// appear on a result sheet, rather than a bare percentage.
  double get marks =>
      totalQuestions == 0
      ? 0
      : (score / totalQuestions) * CbtExamConfig.totalMarks;

  /// Rounded for display. Kept separate from [marks] so a half mark is not
  /// lost before any arithmetic that needs it.
  int get marksAwarded => marks.round();

  static const int totalMarks = CbtExamConfig.totalMarks;

  String get grade {
    final double p = percentage;
    if (p >= 70) return 'A';
    if (p >= 60) return 'B';
    if (p >= 50) return 'C';
    if (p >= 45) return 'D';
    if (p >= 40) return 'E';
    return 'F';
  }

  String get verdict {
    final double p = percentage;
    if (p >= 70) return 'Excellent';
    if (p >= 60) return 'Very good';
    if (p >= 50) return 'Good';
    if (p >= 45) return 'Fair';
    if (p >= 40) return 'Pass';
    return 'Needs work';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'subject_id': subjectId,
    'subject_name': subjectName,
    'total_questions': totalQuestions,
    'answers': answers,
    'score': score,
    'duration_seconds': durationSeconds,
    'taken_at': takenAt.toIso8601String(),
  };

  factory CbtAttempt.fromJson(Map<String, dynamic> json) => CbtAttempt(
    subjectId: (json['subject_id'] ?? '') as String,
    subjectName: (json['subject_name'] ?? '') as String,
    totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 0,
    answers: (json['answers'] as Map<dynamic, dynamic>? ?? <dynamic, dynamic>{})
        .map(
          (dynamic k, dynamic v) =>
              MapEntry<String, int>(k.toString(), (v as num).toInt()),
        ),
    score: (json['score'] as num?)?.toInt() ?? 0,
    durationSeconds: (json['duration_seconds'] as num?)?.toInt() ?? 0,
    takenAt:
        DateTime.tryParse((json['taken_at'] ?? '') as String) ?? DateTime.now(),
  );
}
