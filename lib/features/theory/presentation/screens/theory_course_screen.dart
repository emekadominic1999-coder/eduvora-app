import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/models/theory.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'theory_question_screen.dart';

/// The free theory questions of one course. Students can filter by topic and
/// start a shuffled round of however many questions they want.
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
  final Set<String> _topics = <String>{};
  int _count = 5;

  static const List<int> _counts = <int>[5, 10, 15, 20];

  List<String> get _allTopics {
    final Set<String> t = <String>{
      for (final TheoryQuestion q in widget.questions)
        if (q.topic.trim().isNotEmpty) q.topic.trim(),
    };
    return t.toList()..sort();
  }

  List<TheoryQuestion> get _pool => widget.questions
      .where((TheoryQuestion q) => _topics.isEmpty || _topics.contains(q.topic))
      .toList();

  void _open(List<TheoryQuestion> list, int index) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TheoryQuestionScreen(questions: list, index: index),
      ),
    );
  }

  void _shuffled() {
    final List<TheoryQuestion> pool = _pool..shuffle(Random());
    if (pool.isEmpty) return;
    _open(pool.take(min(_count, pool.length)).toList(), 0);
  }

  @override
  Widget build(BuildContext context) {
    final List<TheoryQuestion> pool = _pool;
    final List<String> topics = _allTopics;
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: Text('${widget.code} theory')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: <Widget>[
          if (topics.length > 1) ...<Widget>[
            const Text(
              'Topics',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: <Widget>[
                for (final String t in topics)
                  FilterChip(
                    label: Text(t),
                    selected: _topics.contains(t),
                    onSelected: (bool on) =>
                        setState(() => on ? _topics.add(t) : _topics.remove(t)),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          EduvoraCard(
            colour: AppColours.primaryTint,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Shuffled practice',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  _topics.isEmpty
                      ? 'Random questions from all topics (${pool.length} available).'
                      : 'Random questions from your chosen topics (${pool.length} available).',
                  style: const TextStyle(color: AppColours.textMuted),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  children: <Widget>[
                    for (final int n in _counts)
                      ChoiceChip(
                        label: Text('$n'),
                        selected: _count == n,
                        onSelected: (_) => setState(() => _count = n),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColours.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: pool.isEmpty ? null : _shuffled,
                  child: const Text('Start shuffled practice'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'All questions',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (int i = 0; i < pool.length; i++) ...<Widget>[
            EduvoraCard(
              onTap: () => _open(pool, i),
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
                          pool[i].topic.isEmpty ? 'Theory' : pool[i].topic,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColours.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          pool[i].question,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}
