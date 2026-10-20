import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data' show BytesBuilder;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/study_material.dart';
import '../../../../core/services/content_repository.dart';
import '../../../../core/theme/app_theme.dart';

/// Shows a study material's file inside the app — a PDF is paginated
/// in-place, an image is shown zoomable — so students never have to
/// download the file to their device just to read it.
///
/// Files kept in the private R2 bucket are strictly view-only: the link is
/// short-lived, nothing here offers download/share/open-elsewhere, and on
/// Android the screen is protected from screenshots while it is open.
class MaterialViewerScreen extends StatefulWidget {
  const MaterialViewerScreen({super.key, required this.material});

  final StudyMaterial material;

  @override
  State<MaterialViewerScreen> createState() => _MaterialViewerScreenState();
}

class _MaterialViewerScreenState extends State<MaterialViewerScreen> {
  static const ContentRepository _content = ContentRepository();
  static const MethodChannel _secureChannel = MethodChannel(
    'eduvora/secure_screen',
  );

  /// Files already downloaded in this session, newest last. Re-opening a
  /// material then costs no data and no waiting.
  static final Map<String, Uint8List> _cache = <String, Uint8List>{};
  static const int _cacheLimit = 3;

  /// Download progress for the loading screen: bytes received and the total
  /// size when the server tells us (or null when unknown).
  final ValueNotifier<(int, int?)> _progress = ValueNotifier<(int, int?)>((
    0,
    null,
  ));

  PdfControllerPinch? _pdfController;
  String? _url;
  bool _resolving = true;
  bool _resolveFailed = false;
  String? _error;

  bool get _isPdf => widget.material.extension == 'PDF';
  bool get _isImage => <String>[
    'PNG',
    'JPG',
    'JPEG',
    'WEBP',
  ].contains(widget.material.extension);
  bool get _isPrivate =>
      widget.material.fileUrl.startsWith(ContentRepository.r2Scheme);

  @override
  void initState() {
    super.initState();
    _setSecure(true);
    _resolve();
  }

  Future<void> _resolve() async {
    setState(() {
      _resolving = true;
      _resolveFailed = false;
      _error = null;
    });
    try {
      final String url = await _content.resolveMaterialUrl(widget.material);
      if (!mounted) return;
      setState(() {
        _url = url;
        _resolving = false;
        if (_isPdf) {
          _pdfController?.dispose();
          _pdfController = PdfControllerPinch(
            document: PdfDocument.openData(_fetchBytes(url)),
          );
        }
      });
    } catch (error) {
      debugPrint('[Eduvora] material link failed: $error');
      if (!mounted) return;
      setState(() {
        _resolving = false;
        _resolveFailed = true;
      });
    }
  }

  Future<Uint8List> _fetchBytes(String url) async {
    final String key = widget.material.id;
    final Uint8List? cached = _cache.remove(key);
    if (cached != null) {
      _cache[key] = cached; // keep it as the newest entry
      return cached;
    }

    final http.Client client = http.Client();
    try {
      final http.StreamedResponse response = await client
          .send(http.Request('GET', Uri.parse(url)))
          .timeout(const Duration(seconds: 45));
      if (response.statusCode != 200) {
        throw StateError('File request failed (${response.statusCode}).');
      }
      final int? total =
          response.contentLength != null && response.contentLength! > 0
          ? response.contentLength
          : (widget.material.fileSizeBytes > 0
                ? widget.material.fileSizeBytes
                : null);
      final BytesBuilder buffer = BytesBuilder(copy: false);
      int received = 0;
      // A download that stops moving for 40 seconds is abandoned, so the
      // student gets a retry button instead of a spinner that never ends.
      await for (final List<int> chunk in response.stream.timeout(
        const Duration(seconds: 40),
      )) {
        buffer.add(chunk);
        received += chunk.length;
        if (mounted) _progress.value = (received, total);
      }
      final Uint8List bytes = buffer.takeBytes();
      while (_cache.length >= _cacheLimit) {
        _cache.remove(_cache.keys.first);
      }
      _cache[key] = bytes;
      return bytes;
    } finally {
      client.close();
    }
  }

  String _megabytes(int bytes) =>
      (bytes / (1024 * 1024)).toStringAsFixed(bytes < 10 * 1024 * 1024 ? 1 : 0);

  /// The loading view: a spinner, plus how much has arrived so far, so a big
  /// file reads as "working" rather than "stuck".
  Widget _loadingView() {
    final int expected = widget.material.fileSizeBytes;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ValueListenableBuilder<(int, int?)>(
          valueListenable: _progress,
          builder: (BuildContext context, (int, int?) value, Widget? _) {
            final int received = value.$1;
            final int? total = value.$2 ?? (expected > 0 ? expected : null);
            final double? fraction = total != null && total > 0
                ? (received / total).clamp(0.0, 1.0)
                : null;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(
                    value: fraction,
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  received == 0
                      ? 'Opening…'
                      : total != null
                      ? '${_megabytes(received)} of ${_megabytes(total)} MB'
                      : '${_megabytes(received)} MB downloaded',
                  style: const TextStyle(color: Colors.white70),
                ),
                if (total != null && total > 15 * 1024 * 1024) ...<Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'This is a large file. On mobile data it can take a few '
                    'minutes the first time; after that it opens instantly.',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  /// Blocks screenshots and screen recording on Android while a material is
  /// open. Best-effort: any failure is ignored.
  Future<void> _setSecure(bool secure) async {
    if (kIsWeb || !Platform.isAndroid) return;
    try {
      await _secureChannel.invokeMethod<void>('setSecure', secure);
    } catch (_) {
      // Screenshot blocking is a bonus; never break the viewer over it.
    }
  }

  @override
  void dispose() {
    _setSecure(false);
    _pdfController?.dispose();
    _progress.dispose();
    super.dispose();
  }

  /// Only for a legacy public file the in-app viewer genuinely cannot show.
  /// Never offered for private (r2://) files.
  Future<void> _openExternally() async {
    final String? url = _url;
    if (_isPrivate || url == null) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.material.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    if (_resolving) return _loadingView();
    if (_resolveFailed || _url == null) {
      return _errorView(
        message: 'Could not open this material. Check your connection.',
        retry: true,
        allowExternal: false,
      );
    }
    if (_isPdf) {
      if (_pdfController == null) return _loadingView();
      return PdfViewPinch(
        controller: _pdfController!,
        onDocumentError: (Object error) => setState(() {
          _error = 'Could not open this material. Check your connection.';
        }),
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) => _loadingView(),
          pageLoaderBuilder: (_) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          errorBuilder: (_, Object error) => _errorView(
            message:
                _error ??
                'Could not open this material. Check your connection.',
            retry: true,
            allowExternal: true,
          ),
        ),
      );
    }
    if (_isImage) {
      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: Center(
          child: Image.network(
            _url!,
            loadingBuilder: (_, Widget child, ImageChunkEvent? progress) =>
                progress == null
                ? child
                : const CircularProgressIndicator(color: Colors.white),
            errorBuilder: (_, Object error, StackTrace? stack) => _errorView(
              message: 'Could not open this material. Check your connection.',
              retry: true,
              allowExternal: true,
            ),
          ),
        ),
      );
    }
    return _unsupportedView();
  }

  Widget _errorView({
    required String message,
    required bool retry,
    required bool allowExternal,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white70,
              size: 40,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            if (retry) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: _resolve,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Try again'),
              ),
            ],
            if (allowExternal && !_isPrivate) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: _openExternally,
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Open with another app'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _unsupportedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.description_rounded,
              color: Colors.white70,
              size: 40,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${widget.material.extension} files can\'t be previewed in '
              'the app yet.',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            if (!_isPrivate) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: _openExternally,
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Open with another app'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
