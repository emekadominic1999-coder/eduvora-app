import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../config/app_config.dart';
import '../data/seed_content.dart';
import '../models/academic_video.dart';
import '../models/news_item.dart';
import '../models/student_profile.dart';
import '../models/study_material.dart';
import 'local_store.dart';
import 'supabase_service.dart';

/// Reads and writes lecture videos, study materials and the noticeboard.
///
/// Supabase is consulted first when it is available; the bundled starter
/// library fills any gap so a student never lands on an empty screen.
class ContentRepository {
  const ContentRepository();

  static const Uuid _uuid = Uuid();

  // -------------------------------------------------------------- videos

  Future<List<AcademicVideo>> videos(StudentProfile profile) async {
    final List<AcademicVideo> remote = await _remoteVideos(profile);
    final List<AcademicVideo> local = LocalStore.instance
        .readList(StoreKeys.videos)
        .map(AcademicVideo.fromJson)
        .where((AcademicVideo v) => v.department == profile.department)
        .toList();

    final List<AcademicVideo> seeded = SeedContent.videosFor(
      faculty: profile.faculty,
      department: profile.department,
      level: profile.level,
    );

    return _merge<AcademicVideo>(<List<AcademicVideo>>[
      local,
      remote,
      seeded,
    ], (AcademicVideo v) => v.id)..sort(
      (AcademicVideo a, AcademicVideo b) => (b.createdAt ?? DateTime(2000))
          .compareTo(a.createdAt ?? DateTime(2000)),
    );
  }

  Future<List<AcademicVideo>> _remoteVideos(StudentProfile profile) async {
    if (!SupabaseService.isReady) return <AcademicVideo>[];
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('academic_videos')
          .select()
          .eq('department', profile.department)
          .order('created_at', ascending: false)
          .limit(100);
      return rows
          .whereType<Map<String, dynamic>>()
          .map(AcademicVideo.fromJson)
          .toList();
    } catch (error) {
      debugPrint('[Eduvora] video fetch failed: $error');
      return <AcademicVideo>[];
    }
  }

  Future<void> registerView(AcademicVideo video) async {
    if (!SupabaseService.isReady) return;
    try {
      await SupabaseService.client
          .from('academic_videos')
          .update(<String, dynamic>{'views': video.views + 1})
          .eq('id', video.id);
    } catch (_) {
      // View counts are cosmetic; never surface a failure for them.
    }
  }

  // ----------------------------------------------------------- materials

  Future<List<StudyMaterial>> materials(StudentProfile profile) async {
    final List<StudyMaterial> remote = await _remoteMaterials(profile);
    final List<StudyMaterial> local = LocalStore.instance
        .readList(StoreKeys.materials)
        .map(StudyMaterial.fromJson)
        .toList();
    final List<StudyMaterial> seeded = SeedContent.materialsFor(
      faculty: profile.faculty,
      department: profile.department,
      level: profile.level,
      institution: profile.institutionName,
    );

    return _merge<StudyMaterial>(<List<StudyMaterial>>[
      local,
      remote,
      seeded,
    ], (StudyMaterial m) => m.id)..sort(
      (StudyMaterial a, StudyMaterial b) => (b.createdAt ?? DateTime(2000))
          .compareTo(a.createdAt ?? DateTime(2000)),
    );
  }

  Future<List<StudyMaterial>> _remoteMaterials(StudentProfile profile) async {
    if (!SupabaseService.isReady) return <StudyMaterial>[];
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('materials')
          .select()
          .eq('department', profile.department)
          .order('created_at', ascending: false)
          .limit(200);
      return rows
          .whereType<Map<String, dynamic>>()
          .map(StudyMaterial.fromJson)
          .toList();
    } catch (error) {
      debugPrint('[Eduvora] material fetch failed: $error');
      return <StudyMaterial>[];
    }
  }

  /// Publishes a material. [bytes] is optional so a student on a weak network
  /// can still register a resource and attach the file later.
  Future<StudyMaterial> uploadMaterial({
    required StudentProfile profile,
    required String title,
    required String courseCode,
    required String description,
    required MaterialKind kind,
    required String level,
    String fileName = '',
    Uint8List? bytes,
  }) async {
    final String id = _uuid.v4();
    String fileUrl = '';

    if (SupabaseService.isReady && bytes != null && fileName.isNotEmpty) {
      try {
        final String path = '${profile.id}/$id-$fileName';
        await SupabaseService.client.storage
            .from(AppConfig.materialsBucket)
            .uploadBinary(path, bytes);
        fileUrl = SupabaseService.client.storage
            .from(AppConfig.materialsBucket)
            .getPublicUrl(path);
      } catch (error) {
        debugPrint('[Eduvora] material upload failed: $error');
      }
    }

    final StudyMaterial material = StudyMaterial(
      id: id,
      title: title.trim(),
      courseCode: courseCode.trim().toUpperCase(),
      department: profile.department,
      faculty: profile.faculty,
      institution: profile.institutionName,
      level: level,
      fileUrl: fileUrl,
      fileName: fileName,
      fileSizeBytes: bytes?.lengthInBytes ?? 0,
      uploadedBy: profile.id,
      uploaderName: profile.fullName,
      description: description.trim(),
      kind: kind,
      createdAt: DateTime.now(),
    );

    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client
            .from('materials')
            .insert(material.toJson());
      } catch (error) {
        debugPrint('[Eduvora] material insert failed: $error');
      }
    }

    final List<Map<String, dynamic>> cached = LocalStore.instance.readList(
      StoreKeys.materials,
    )..insert(0, material.toJson());
    await LocalStore.instance.writeList(StoreKeys.materials, cached);

    return material;
  }

  /// Materials this student personally contributed.
  Future<List<StudyMaterial>> myUploads(StudentProfile profile) async {
    final List<StudyMaterial> all = LocalStore.instance
        .readList(StoreKeys.materials)
        .map(StudyMaterial.fromJson)
        .where((StudyMaterial m) => m.uploadedBy == profile.id)
        .toList();
    return all;
  }

  // ---------------------------------------------------------------- news

  Future<List<NewsItem>> news() async {
    if (SupabaseService.isReady) {
      try {
        final List<dynamic> rows = await SupabaseService.client
            .from('news')
            .select()
            .order('published_at', ascending: false)
            .limit(60);
        final List<NewsItem> remote = rows
            .whereType<Map<String, dynamic>>()
            .map(NewsItem.fromJson)
            .toList();
        if (remote.isNotEmpty) return remote;
      } catch (error) {
        debugPrint('[Eduvora] news fetch failed: $error');
      }
    }
    return SeedContent.news();
  }

  Set<String> bookmarkedNewsIds() => LocalStore.instance
      .readList(StoreKeys.bookmarkedNews)
      .map((Map<String, dynamic> m) => (m['id'] ?? '') as String)
      .where((String id) => id.isNotEmpty)
      .toSet();

  Future<void> toggleNewsBookmark(String id) async {
    final Set<String> current = bookmarkedNewsIds();
    if (!current.remove(id)) current.add(id);
    await LocalStore.instance.writeList(
      StoreKeys.bookmarkedNews,
      current.map((String e) => <String, dynamic>{'id': e}).toList(),
    );
  }

  // ------------------------------------------------------------- helpers

  /// Combines several sources, keeping the first occurrence of each key so
  /// locally created records always win over seeded ones.
  static List<T> _merge<T>(List<List<T>> sources, String Function(T) keyOf) {
    final Map<String, T> byKey = <String, T>{};
    for (final List<T> source in sources) {
      for (final T item in source) {
        byKey.putIfAbsent(keyOf(item), () => item);
      }
    }
    return byKey.values.toList();
  }
}
