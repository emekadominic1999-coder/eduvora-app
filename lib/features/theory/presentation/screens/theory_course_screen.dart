import 'package:flutter/material.dart';

import '../../../../core/models/theory.dart';
import '../../../../core/services/local_store.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'theory_question_screen.dart';

String theoryScoreKey(String id) => 'eduvora.theory.score.$id';

/// The questions of one course, with the student's best score on each.
class TheoryCourseScreen extends StatefulWidget {
  const TheoryCourseScreen({
    super.key,
    required this.code,
    required this.questions,
  });

  final String code;
  final List<TheoryQuestion> questions;

  @override
  State<TheoryCourseScreen> createState() => _TheoryCourseScreenState();
}

class _TheoryCourseScreenState extends State<TheoryCourseScreen> {
  int? _best(String id) => LocalStore.isReady
      ? int.tryParse(LocalStore.instance.readString(theoryScoreKey(id)) ?? '')
      : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: Text('${widget.code} theory')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: widget.questions.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: AppSpacing.md),
        itemBuilder: (BuildContext context, int i) {
          final TheoryQuestion q = widget.questions[i];
          final int? best = _best(q.id);
          return EduvoraCard(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => TheoryQuestionScreen(question: q),
                ),
              );
              if (mounted) setState(() {});
            },
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
                const SizedBox(width: AppSpacing.sm),
                Column(
                  children: <Widget>[
                    Text(
                      '${q.marks} marks',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (best != null)
                      Text(
                        'Best $best/${q.marks}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColours.success,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
