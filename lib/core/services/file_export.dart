import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Hands a generated text file to the device.
///
/// On the web this opens a data URL, which the browser downloads. On mobile
/// there is no browser to hand off to, so the caller is told to share the
/// contents another way rather than being left with a button that silently
/// does nothing.
class FileExport {
  const FileExport._();

  static bool get isSupported => kIsWeb;

  /// Returns true when the download was handed off successfully.
  static Future<bool> downloadCsv({
    required String fileName,
    required String contents,
  }) async {
    if (!kIsWeb) return false;

    try {
      // A data URL keeps this dependency-free; CSV of a class list is small
      // enough that the URL length limit is not a concern.
      final String encoded = base64Encode(utf8.encode(contents));
      final Uri uri = Uri.parse(
        'data:text/csv;charset=utf-8;base64,$encoded',
      );
      return launchUrl(uri, webOnlyWindowName: '_blank');
    } catch (error) {
      debugPrint('[Eduvora] CSV export failed: $error');
      return false;
    }
  }
}
