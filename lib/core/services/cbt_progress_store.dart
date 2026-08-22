import 'local_store.dart';

/// Reads the single saved in-progress CBT attempt (if any), shared between
/// [CbtExamScreen] (which owns writing/clearing it) and anywhere that needs
/// to know one exists without pulling in the exam screen itself — chiefly
/// the home shell, which uses this to walk a student straight back into an
/// exam a reload interrupted, rather than leaving them stranded on the
/// dashboard wondering where their paper went.
class CbtProgressStore {
  const CbtProgressStore._();

  /// How long a saved attempt is trusted as "interrupted" rather than
  /// abandoned. Must match the window [CbtExamScreen] itself uses.
  static const Duration resumeWindow = Duration(hours: 6);

  /// The saved attempt, if one exists and is still within [resumeWindow].
  static Map<String, dynamic>? readValid() {
    if (!LocalStore.isReady) return null;
    final Map<String, dynamic>? saved = LocalStore.instance.readMap(
      StoreKeys.cbtInProgress,
    );
    if (saved == null) return null;
    final String? savedAtRaw = saved['savedAt'] as String?;
    if (savedAtRaw == null) return null;
    final DateTime? savedAt = DateTime.tryParse(savedAtRaw);
    if (savedAt == null) return null;
    if (DateTime.now().difference(savedAt) > resumeWindow) return null;
    final List<dynamic>? questions = saved['questions'] as List<dynamic>?;
    if (questions == null || questions.isEmpty) return null;
    if (saved['subjectId'] == null) return null;
    return saved;
  }
}
