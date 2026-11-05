import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/models/course_outline.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/models/theory.dart';
import '../../../../core/services/course_repository.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'theory_question_screen.dart';

/// Make your own theory practice: pick a course, the topics and how many
/// questions, and the AI writes a fresh set with model answers.
class TheoryGeneratorScreen extends StatefulWidget {
  const TheoryGeneratorScreen({super.key});

  @override
  State<TheoryGeneratorScreen> createState() => _TheoryGeneratorScreenState();
}

class _TheoryGeneratorScreenState extends State<TheoryGeneratorScreen> {
  List<CourseOutline> _courses = const <CourseOutline>[];
  bool _loading = true;
  CourseOutline? _course;
  final Set<String> _topics = <String>{};
  final TextEditingController _typedCode = TextEditingController();
  final TextEditingController _typedTopic = TextEditingController();
  int _count = 5;
  bool _busy = false;
  String? _error;

  static const List<int> _counts = <int>[5, 8, 10, 15];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _typedCode.dispose();
    _typedTopic.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      await sessionController.ensureLoaded();
      final StudentProfile? profile = sessionController.profile;
      if (profile != null) {
        final List<CourseOutline> list = await const CourseRepository()
            .forStudent(profile);
        list.sort(
          (CourseOutline a, CourseOutline b) =>
              a.courseCode.compareTo(b.courseCode),
        );
        _courses = list;
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _generate() async {
    final String typed = _typedCode.text.trim();
    final String code = _course?.courseCode ?? typed;
    final String title = _course?.courseTitle ?? '';
    if (code.isEmpty) {
      setState(() => _error = 'Choose a course or type its code first.');
      return;
    }
    if (!SupabaseService.isReady) {
      setState(() => _error = 'You need an internet connection.');
      return;
    }
    final List<String> topics = <String>[..._topics];
    final String extra = _typedTopic.text.trim();
    if (extra.isNotEmpty) topics.add(extra);

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final FunctionResponse res = await SupabaseService.client.functions
          .invoke(
            'solve-question',
            body: <String, dynamic>{
              'mode': 'generate',
              'courseCode': code,
              'courseTitle': title,
              'topics': topics,
              'count': _count,
            },
          );
      final Object? data = res.data;
      if (data is Map && data['questions'] is List) {
        final List<TheoryQuestion> questions = <TheoryQuestion>[];
        for (final Object? q in data['questions'] as List<dynamic>) {
          if (q is! Map) continue;
          final String text = (q['question'] ?? '').toString().trim();
          final String answer = (q['answer'] ?? '').toString().trim();
          if (text.isEmpty || answer.isEmpty) continue;
          final List<dynamic> pts = q['keyPoints'] is List
              ? q['keyPoints'] as List<dynamic>
              : const <dynamic>[];
          questions.add(
            TheoryQuestion(
              id: 'gen-${questions.length}',
              courseCode: code,
              courseTitle: title,
              topic: (q['topic'] ?? '').toString(),
              question: text,
              marks: (q['marks'] as num?)?.toInt() ?? 5,
              modelAnswer: answer,
              keyPoints: pts
                  .map((dynamic p) => p.toString())
                  .where((String p) => p.trim().isNotEmpty)
                  .map((String p) => TheoryKeyPoint(text: p, marks: 1))
                  .toList(),
            ),
          );
        }
        if (questions.isEmpty) {
          setState(() => _error = 'No questions came back. Please try again.');
        } else if (mounted) {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) =>
                  TheoryQuestionScreen(questions: questions, index: 0),
            ),
          );
        }
      } else {
        setState(
          () => _error = data is Map && data['error'] is String
              ? data['error'] as String
              : 'Could not make questions. Try again.',
        );
      }
    } on FunctionException catch (e) {
      final Object? d = e.details;
      setState(
        () => _error = d is Map && d['error'] is String
            ? d['error'] as String
            : 'The question maker is not available right now.',
      );
    } catch (_) {
      setState(() => _error = 'Something went wrong. Check your connection.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> offered = _course?.topics ?? const <String>[];
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Make theory questions')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: <Widget>[
                const EduvoraCard(
                  colour: AppColours.primaryTint,
                  child: Text(
                    'Choose a course, the topics and how many questions you '
                    'want. Eduvora writes a fresh set with full answers. '
                    'These are AI-written, so check them against your notes.',
                    style: TextStyle(height: 1.4),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Course',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (_courses.isNotEmpty)
                  DropdownButtonFormField<CourseOutline>(
                    isExpanded: true,
                    initialValue: _course,
                    hint: const Text('Pick one of your courses'),
                    items: <DropdownMenuItem<CourseOutline>>[
                      for (final CourseOutline c in _courses)
                        DropdownMenuItem<CourseOutline>(
                          value: c,
                          child: Text(
                            '${c.courseCode}: ${c.courseTitle}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (CourseOutline? c) => setState(() {
                      _course = c;
                      _topics.clear();
                    }),
                  ),
                if (_courses.isNotEmpty) const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _typedCode,
                  textCapitalization: TextCapitalization.characters,
                  enabled: _course == null,
                  decoration: const InputDecoration(
                    labelText: 'Or type a course code, for example PHY 102',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Topics (optional)',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (offered.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: <Widget>[
                      for (final String t in offered)
                        FilterChip(
                          label: Text(t),
                          selected: _topics.contains(t),
                          onSelected: (bool on) => setState(
                            () => on ? _topics.add(t) : _topics.remove(t),
                          ),
                        ),
                    ],
                  ),
                if (offered.isNotEmpty) const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _typedTopic,
                  decoration: const InputDecoration(
                    labelText: 'Or type a topic you want',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'How many questions?',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
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
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColours.primary,
                    minimumSize: const Size.fromHeight(54),
                  ),
                  onPressed: _busy ? null : _generate,
                  child: _busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Make my questions'),
                ),
                if (_error != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  EduvoraCard(
                    colour: AppColours.dangerSoft,
                    child: Text(_error!),
                  ),
                ],
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
    );
  }
}
