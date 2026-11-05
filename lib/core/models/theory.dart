/// One marking point in a theory question's marking guide.
class TheoryKeyPoint {
  const TheoryKeyPoint({required this.text, required this.marks});

  final String text;
  final int marks;

  factory TheoryKeyPoint.fromJson(Map<String, dynamic> json) => TheoryKeyPoint(
    text: (json['t'] ?? '').toString(),
    marks: (json['m'] as num?)?.toInt() ?? 1,
  );
}

/// A written (theory) exam question with its model answer and marking guide.
class TheoryQuestion {
  const TheoryQuestion({
    required this.id,
    required this.courseCode,
    required this.courseTitle,
    required this.topic,
    required this.question,
    required this.marks,
    required this.modelAnswer,
    required this.keyPoints,
  });

  final String id;
  final String courseCode;
  final String courseTitle;
  final String topic;
  final String question;
  final int marks;
  final String modelAnswer;
  final List<TheoryKeyPoint> keyPoints;

  factory TheoryQuestion.fromJson(Map<String, dynamic> json) {
    final Object? raw = json['key_points'];
    return TheoryQuestion(
      id: (json['id'] ?? '').toString(),
      courseCode: (json['course_code'] ?? '').toString(),
      courseTitle: (json['course_title'] ?? '').toString(),
      topic: (json['topic'] ?? '').toString(),
      question: (json['question'] ?? '').toString(),
      marks: (json['marks'] as num?)?.toInt() ?? 5,
      modelAnswer: (json['model_answer'] ?? '').toString(),
      keyPoints: raw is List
          ? raw
                .whereType<Map<dynamic, dynamic>>()
                .map(
                  (Map<dynamic, dynamic> m) =>
                      TheoryKeyPoint.fromJson(Map<String, dynamic>.from(m)),
                )
                .toList()
          : const <TheoryKeyPoint>[],
    );
  }
}
