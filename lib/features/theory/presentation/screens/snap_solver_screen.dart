import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// Snap a question: the student photographs a question or equation and gets a
/// step-by-step solution.
class SnapSolverScreen extends StatefulWidget {
  const SnapSolverScreen({super.key});

  @override
  State<SnapSolverScreen> createState() => _SnapSolverScreenState();
}

class _SnapSolverScreenState extends State<SnapSolverScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _photo;
  String _mime = 'image/jpeg';
  bool _busy = false;
  String? _solution;
  String? _error;
  int? _remaining;

  Future<void> _pick(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 80,
      );
      if (file == null) return;
      final Uint8List bytes = await file.readAsBytes();
      setState(() {
        _photo = bytes;
        _mime = file.name.toLowerCase().endsWith('.png')
            ? 'image/png'
            : 'image/jpeg';
        _solution = null;
        _error = null;
      });
    } catch (_) {
      setState(() => _error = 'Could not open the photo. Please try again.');
    }
  }

  Future<void> _solve() async {
    final Uint8List? photo = _photo;
    if (photo == null || _busy) return;
    if (!SupabaseService.isReady) {
      setState(() => _error = 'You need an internet connection to solve.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _solution = null;
    });
    try {
      final FunctionResponse res = await SupabaseService.client.functions
          .invoke(
            'solve-question',
            body: <String, dynamic>{
              'image': base64Encode(photo),
              'mimeType': _mime,
            },
          );
      final Object? data = res.data;
      if (data is Map && data['solution'] is String) {
        setState(() {
          _solution = data['solution'] as String;
          _remaining = (data['remaining'] as num?)?.toInt();
        });
      } else {
        setState(
          () => _error = data is Map && data['error'] is String
              ? data['error'] as String
              : 'No answer came back. Try a clearer photo.',
        );
      }
    } on FunctionException catch (e) {
      final Object? d = e.details;
      setState(
        () => _error = d is Map && d['error'] is String
            ? d['error'] as String
            : 'The solver is not available right now. Try again soon.',
      );
    } catch (_) {
      setState(
        () => _error = 'Something went wrong. Check your connection and retry.',
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Snap a question')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: <Widget>[
          const EduvoraCard(
            colour: AppColours.primaryTint,
            child: Text(
              'Take a clear photo of a question or equation and get a '
              'step-by-step solution. The AI can make mistakes, so always '
              'check important answers with your lecturer or textbook.',
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
                  onPressed: _busy ? null : () => _pick(ImageSource.camera),
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
                  onPressed: _busy ? null : () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_rounded),
                  label: const Text('Choose photo'),
                ),
              ),
            ],
          ),
          if (_photo != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.memory(_photo!, fit: BoxFit.contain),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColours.accent,
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: _busy ? null : _solve,
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Solve this question'),
            ),
          ],
          if (_error != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            EduvoraCard(
              colour: AppColours.dangerSoft,
              child: Text(_error!),
            ),
          ],
          if (_solution != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Solution',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: AppSpacing.sm),
            EduvoraCard(
              child: SelectableText(
                _solution!,
                style: const TextStyle(fontSize: 15, height: 1.55),
              ),
            ),
            if (_remaining != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Text(
                '$_remaining free solution${_remaining == 1 ? '' : 's'} left today',
                style: const TextStyle(color: AppColours.textMuted),
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}
