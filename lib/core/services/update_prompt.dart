import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import 'local_store.dart';
import 'supabase_service.dart';

/// Tells students on an old version of Eduvora to update from Google Play.
///
/// The newest build number lives in one row of the `app_update` table
/// (`supabase/APP_UPDATE_PROMPT.sql`). After each release, change
/// `latest_build` there and every older app shows the prompt. Raise
/// `min_build` as well to make the update compulsory.
class UpdatePrompt {
  const UpdatePrompt._();

  static const String playUrl =
      'https://play.google.com/store/apps/details?id=com.dominicemeka.eduvora';
  static const String _snoozeKey = 'eduvora.update.snoozed_build';

  static bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool _checked = false;

  /// Call once after the signed-in home screen appears. Quiet on any failure.
  static Future<void> check(BuildContext context) async {
    if (_checked || !_supported || !SupabaseService.isReady) return;
    _checked = true;
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      final int mine = int.tryParse(info.buildNumber) ?? 0;
      final Map<String, dynamic>? row = await SupabaseService.client
          .from('app_update')
          .select('latest_build, min_build, message')
          .eq('id', 1)
          .maybeSingle();
      if (row == null) return;
      final int latest = (row['latest_build'] as num?)?.toInt() ?? 0;
      final int minimum = (row['min_build'] as num?)?.toInt() ?? 0;
      if (mine >= latest) return;
      final bool must = mine < minimum;
      // "Later" hides the prompt for that release until the next one.
      if (!must &&
          LocalStore.isReady &&
          LocalStore.instance.readString(_snoozeKey) == '$latest') {
        return;
      }
      if (!context.mounted) return;
      final String message = (row['message'] as String?)?.trim().isNotEmpty ==
              true
          ? row['message'] as String
          : 'A new version of Eduvora is ready with new questions, notes and '
                'improvements.';
      final bool? yes = await showDialog<bool>(
        context: context,
        barrierDismissible: !must,
        builder: (BuildContext ctx) => PopScope(
          canPop: !must,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Text('Update Eduvora'),
            content: Text(message),
            actions: <Widget>[
              if (!must)
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Later'),
                ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColours.primary,
                ),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Update now'),
              ),
            ],
          ),
        ),
      );
      if (yes == true) {
        await launchUrl(Uri.parse(playUrl), mode: LaunchMode.externalApplication);
      } else if (LocalStore.isReady) {
        await LocalStore.instance.writeString(_snoozeKey, '$latest');
      }
    } catch (error) {
      debugPrint('[Eduvora] update check failed: $error');
    }
  }
}
