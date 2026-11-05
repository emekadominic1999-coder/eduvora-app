import 'package:flutter/material.dart';

import '../../../../core/models/theory.dart';
import '../../../../core/services/theory_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'theory_course_screen.dart';

/// Theory practice: pick a course, answer on paper or aloud, then mark
/// yourself against the marking guide.
class TheoryHomeScreen extends StatefulWidget {
  const TheoryHomeScreen({super.key});

  @override
  State<TheoryHomeScreen> createState() => _TheoryHomeScreenState();
}

class _TheoryHomeScreenState extends State<TheoryHomeScreen> {
  late Future<List<TheoryQuestion>> _future;

  @override
  void initState() {
    super.initState();
    _future = const TheoryRepository().all();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Theory practice')),
      body: FutureBuilder<List<TheoryQuestion>>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<TheoryQuestion>> s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<TheoryQuestion> all = s.data ?? const <TheoryQuestion>[];
          final Map<String, List<TheoryQuestion>> byCourse =
              <String, List<TheoryQuestion>>{};
          for (final TheoryQuestion q in all) {
            byCourse.putIfAbsent(q.courseCode, () => <TheoryQuestion>[]).add(q);
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: <Widget>[
              const EduvoraCard(
                colour: AppColours.primaryTint,
                child: Text(
                  'Read each written exam question and think about how you '
                  'would answer it. Then tap Show answer to see a full model '
                  'answer and the key points to remember.',
                  style: TextStyle(color: AppColours.text, height: 1.4),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (byCourse.isEmpty)
                const EduvoraCard(
                  child: Text(
                    'No theory questions yet, or you are offline. Check your '
                    'connection and try again. More courses are on the way.',
                  ),
                ),
              for (final MapEntry<String, List<TheoryQuestion>> e
                  in byCourse.entries) ...<Widget>[
                EduvoraCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          TheoryCourseScreen(code: e.key, questions: e.value),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      const CircleAvatar(
                        backgroundColor: AppColours.primarySoft,
                        child: Icon(
                          Icons.edit_note_rounded,
                          color: AppColours.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${e.key}: ${e.value.first.courseTitle}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${e.value.length} theory questions',
                              style: const TextStyle(
                                color: AppColours.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        },
      ),
    );
  }
}
