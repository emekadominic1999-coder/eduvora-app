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
  });

  final String id;
  final String name;
  final String description;
  final List<CbtQuestion> questions;

  /// Faculties this paper is aimed at; empty means every student.
  final List<String> faculties;
  final int minutesPerAttempt;
  final bool isGeneralStudies;

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

  /// The paper exactly as it was written.
  factory CbtExamConfig.standard(CbtSubject subject) => CbtExamConfig(
    questionCount: subject.questions.length,
    minutes: subject.minutesPerAttempt,
  );

  final int questionCount;
  final int minutes;
  final bool shuffleQuestions;
  final bool shuffleOptions;
  final bool isCustom;

  Duration get duration => Duration(minutes: minutes);

  /// Builds the working question list for an attempt, applying the count and
  /// any shuffling. [seed] keeps a given attempt reproducible for tests.
  List<CbtQuestion> buildPaper(CbtSubject subject, {int? seed}) {
    final Random rng = Random(seed ?? DateTime.now().microsecondsSinceEpoch);
    final List<CbtQuestion> pool = List<CbtQuestion>.from(subject.questions);

    if (shuffleQuestions) pool.shuffle(rng);

    final int take = questionCount.clamp(1, pool.length);
    final List<CbtQuestion> paper = pool.take(take).toList();

    if (!shuffleOptions) return paper;
    return paper.map((CbtQuestion q) => q.withShuffledOptions(rng)).toList();
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
