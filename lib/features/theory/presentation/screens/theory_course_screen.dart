import 'package:flutter/material.dart';

import '../../../../core/models/theory.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'theory_question_screen.dart';

/// The theory questions of one course.
class TheoryCourseScreen extends StatelessWidget {
  const TheoryCourseScreen({
    super.key,
    required this.code,
    required this.questions,
  });

  final String code;
  final List<TheoryQuestion> questions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: Text('$code theory')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: questions.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: AppSpacing.md),
        itemBuilder: (BuildContext context, int i) {
          final TheoryQuestion q = questions[i];
          return EduvoraCard(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    TheoryQuestionScreen(questions: questions, index: i),
              ),
            ),
            child: Row(
              children: <Widget>[
                Text(
                  '${i + 1}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColours.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        q.topic.isEmpty ? 'Theory' : q.topic,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColours.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        q.question,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          );
        },
      ),
    );
  }
}
