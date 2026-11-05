import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/models/theory.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'theory_question_screen.dart';

/// Study from my notes: the student photographs the pages they are studying
/// and gets exam-style questions with answers taken from those pages.
class TheoryNotesScreen extends StatefulWidget {
  const TheoryNotesScreen({super.key});

  @override
  State<TheoryNotesScreen> createState() => _TheoryNotesScreenState();
}

class _TheoryNotesScreenState extends State<TheoryNotesScreen> {
  static const int _maxPages = 6;
  static const List<int> _counts = <int>[5, 8, 10, 15];

  final ImagePicker _picker = ImagePicker();
  final List<Uint8List> _pages = <Uint8List>[];
  final TextEditingController _topic = TextEditingController();
  int _count = 5;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _topic.dispose();
    super.dispose();
  }

  Future<void> _addFromCamera() async {
    if (_pages.length >= _maxPages) return;
    try {
      final XFile? f = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1600,
        imageQuality: 80,
      );
      if (f == null) return;
      final Uint8List bytes = await f.readAsBytes();
      setState(() => _pages.add(bytes));
    } catch (_) {
      setState(() => _error = 'Could not open the camera.');
    }
  }

  Future<void> _addFromGallery() async {
    try {
      final List<XFile> files = await _picker.pickMultiImage(
        maxWidth: 1600,
        imageQuality: 80,
      );
      for (final XFile f in files) {
        if (_pages.length >= _maxPages) break;
        _pages.add(await f.readAsBytes());
      }
      if (mounted) setState(() {});
    } catch (_) {
      setState(() => _error = 'Could not open your photos.');
    }
  }

  Future<void> _make() async {
    if (_pages.isEmpty || _busy) return;
    if (!SupabaseService.isReady) {
      setState(() => _error = 'You need an internet connection.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final String topic = _topic.text.trim();
      final FunctionResponse res = await SupabaseService.client.functions
          .invoke(
            'solve-question',
            body: <String, dynamic>{
              'mode': 'notes',
              'images': _pages.map(base64Encode).toList(),
              'count': _count,
              'topics': topic.isEmpty ? <String>[] : <String>[topic],
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
              id: 'notes-${questions.length}',
              courseCode: 'My notes',
              courseTitle: '',
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
          setState(() => _error = 'No questions came back. Try clearer photos.');
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
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Study from my notes')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: <Widget>[
          const EduvoraCard(
            colour: AppColours.primaryTint,
            child: Text(
              'Add photos of the pages you are studying, up to 6. Eduvora '
              'writes exam-style questions with answers taken from those '
              'pages, so they match your textbook or lecture notes. Use '
              'clear, well-lit photos of the text.',
              style: TextStyle(height: 1.4),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColours.primary,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _busy || _pages.length >= _maxPages
                      ? null
                      : _addFromCamera,
                  icon: const Icon(Icons.photo_camera_rounded),
                  label: const Text('Take photo'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _busy || _pages.length >= _maxPages
                      ? null
                      : _addFromGallery,
                  icon: const Icon(Icons.photo_library_rounded),
                  label: const Text('Choose photos'),
                ),
              ),
            ],
          ),
          if (_pages.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text(
              '${_pages.length} of $_maxPages pages added',
              style: const TextStyle(color: AppColours.textMuted),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _pages.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 8),
                itemBuilder: (BuildContext context, int i) => Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        _pages[i],
                        height: 110,
                        width: 84,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _busy
                            ? null
                            : () => setState(() => _pages.removeAt(i)),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(3),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Topic to focus on (optional)',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _topic,
            decoration: const InputDecoration(
              labelText: 'For example: Newton\'s laws',
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
              backgroundColor: AppColours.accent,
              minimumSize: const Size.fromHeight(54),
            ),
            onPressed: _busy || _pages.isEmpty ? null : _make,
            child: _busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text('Make questions from my notes'),
          ),
          if (_error != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            EduvoraCard(colour: AppColours.dangerSoft, child: Text(_error!)),
          ],
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}
