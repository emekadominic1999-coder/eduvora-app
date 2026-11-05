import 'package:flutter/material.dart';

import '../../../../core/models/theory.dart';
import '../../../../core/services/theory_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'snap_solver_screen.dart';
import 'theory_course_screen.dart';
import 'theory_generator_screen.dart';
import 'theory_notes_screen.dart';

/// Theory practice. Free: written questions by course and topic, shuffled for
/// each practice round. Paid: the AI tools (study from your notes, AI-made
/// question sets, snap-a-question).
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

  void _open(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
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
              const Text(
                'Free practice',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              const SizedBox(height: 4),
              const Text(
                'Written exam questions by course and topic. Read the '
                'question, think it through, then tap Show answer. Practise '
                'shuffled sets as often as you like.',
                style: TextStyle(color: AppColours.textMuted, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.md),
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
                  onTap: () => _open(
                    TheoryCourseScreen(code: e.key, questions: e.value),
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
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: <Widget>[
                  const Text(
                    'AI tools',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColours.accentSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'PAID',
                      style: TextStyle(
                        color: AppColours.accentDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Smarter practice powered by AI. These need an AI pass.',
                style: TextStyle(color: AppColours.textMuted),
              ),
              const SizedBox(height: AppSpacing.md),
              _AiCard(
                icon: Icons.menu_book_rounded,
                colour: AppColours.primarySoft,
                iconColour: AppColours.primary,
                title: 'Study from my notes',
                body:
                    'Photograph the pages you are studying and get questions '
                    'with answers taken from them.',
                onTap: () => _open(const TheoryNotesScreen()),
              ),
              const SizedBox(height: AppSpacing.md),
              _AiCard(
                icon: Icons.auto_awesome_rounded,
                colour: AppColours.successSoft,
                iconColour: AppColours.success,
                title: 'AI-made question sets',
                body:
                    'Choose a course, topics and 5 or more questions. The AI '
                    'writes a fresh set with answers.',
                onTap: () => _open(const TheoryGeneratorScreen()),
              ),
              const SizedBox(height: AppSpacing.md),
              _AiCard(
                icon: Icons.photo_camera_rounded,
                colour: AppColours.accentSoft,
                iconColour: AppColours.accent,
                title: 'Snap a question',
                body:
                    'Photograph any question or equation and get a '
                    'step-by-step solution.',
                onTap: () => _open(const SnapSolverScreen()),
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          );
        },
      ),
    );
  }
}

class _AiCard extends StatelessWidget {
  const _AiCard({
    required this.icon,
    required this.colour,
    required this.iconColour,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final Color colour;
  final Color iconColour;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      colour: colour,
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Icon(icon, color: iconColour),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(body, style: const TextStyle(height: 1.35)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
