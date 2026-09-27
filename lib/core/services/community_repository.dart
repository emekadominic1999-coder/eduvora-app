import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/community.dart';
import '../models/student_profile.dart';
import 'local_store.dart';
import 'supabase_service.dart';

/// Posts, likes and comments in the Eduvora community.
class CommunityRepository {
  const CommunityRepository();

  static const Uuid _uuid = Uuid();

  Future<List<CommunityPost>> posts({CommunityTopic? topic}) async {
    final List<CommunityPost> local = LocalStore.instance
        .readList(StoreKeys.communityPosts)
        .map(CommunityPost.fromJson)
        .toList();

    List<CommunityPost> remote = <CommunityPost>[];
    if (SupabaseService.isReady) {
      try {
        final List<dynamic> rows = await SupabaseService.client
            .from('community_posts')
            .select()
            .order('created_at', ascending: false)
            .limit(120);
        remote = rows
            .whereType<Map<String, dynamic>>()
            .map(CommunityPost.fromJson)
            .toList();
      } catch (error) {
        debugPrint('[Eduvora] community fetch failed: $error');
      }
    }

    final Map<String, CommunityPost> byId = <String, CommunityPost>{};
    for (final CommunityPost p in <CommunityPost>[
      ...local,
      ...remote,
    ]) {
      byId.putIfAbsent(p.id, () => p);
    }

    final List<CommunityPost> all = byId.values.toList()
      ..sort((CommunityPost a, CommunityPost b) {
        if (a.isAnnouncement != b.isAnnouncement) {
          return a.isAnnouncement ? -1 : 1;
        }
        return b.createdAt.compareTo(a.createdAt);
      });

    if (topic == null) return all;
    return all.where((CommunityPost p) => p.topic == topic).toList();
  }

  Future<CommunityPost> createPost({
    required StudentProfile author,
    required String body,
    required CommunityTopic topic,
  }) async {
    final CommunityPost post = CommunityPost(
      id: _uuid.v4(),
      authorId: author.id,
      authorName: author.fullName,
      authorHeadline: author.academicSummary,
      body: body.trim(),
      topic: topic,
      createdAt: DateTime.now(),
      institution: author.institutionName,
      department: author.department,
    );

    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client
            .from('community_posts')
            .insert(post.toJson());
      } catch (error) {
        debugPrint('[Eduvora] post insert failed: $error');
      }
    }

    final List<Map<String, dynamic>> cached = LocalStore.instance.readList(
      StoreKeys.communityPosts,
    )..insert(0, post.toJson());
    await LocalStore.instance.writeList(StoreKeys.communityPosts, cached);
    return post;
  }

  /// Cross-posts a Noticeboard update into Community, pinned to the top.
  ///
  /// Only ever called from [PostNewsScreen], and the database itself is what
  /// actually enforces `is_announcement`: the insert policy on
  /// `community_posts` (see `supabase/OWNER_NEWS_POSTING.sql`) rejects a
  /// true value from anyone but the owner's own signed-in account, so this
  /// is never a way for a student to pin their own post.
  ///
  /// Unlike [createPost], this surfaces a failure rather than swallowing it
  /// — the owner needs to know if the cross-post did not go through, since
  /// nothing else will tell them.
  Future<void> createAnnouncement({
    required String authorName,
    required String body,
    required CommunityTopic topic,
    String imageUrl = '',
  }) async {
    if (!SupabaseService.isReady) {
      throw StateError(
        'Posting to Community needs the Eduvora backend to be connected.',
      );
    }
    final String? userId = SupabaseService.currentUser?.id;
    if (userId == null) {
      throw StateError('Not signed in.');
    }
    final CommunityPost post = CommunityPost(
      id: _uuid.v4(),
      authorId: userId,
      authorName: authorName,
      body: body.trim(),
      topic: topic,
      createdAt: DateTime.now(),
      isAnnouncement: true,
      imageUrl: imageUrl,
    );
    await SupabaseService.client.from('community_posts').insert(post.toJson());
  }

  Set<String> likedPostIds() => LocalStore.instance
      .readList(StoreKeys.likedPosts)
      .map((Map<String, dynamic> m) => (m['id'] ?? '') as String)
      .where((String id) => id.isNotEmpty)
      .toSet();

  /// Returns true when the post is liked after the toggle.
  Future<bool> toggleLike(CommunityPost post) async {
    final Set<String> liked = likedPostIds();
    final bool nowLiked = !liked.remove(post.id);
    if (nowLiked) liked.add(post.id);

    await LocalStore.instance.writeList(
      StoreKeys.likedPosts,
      liked.map((String e) => <String, dynamic>{'id': e}).toList(),
    );

    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client
            .from('community_posts')
            .update(<String, dynamic>{
              'likes': post.likes + (nowLiked ? 1 : -1),
            })
            .eq('id', post.id);
      } catch (_) {
        // Like counts are best-effort.
      }
    }
    return nowLiked;
  }

  Future<List<CommunityComment>> comments(String postId) async {
    final List<CommunityComment> local = LocalStore.instance
        .readList(StoreKeys.communityComments)
        .map(CommunityComment.fromJson)
        .where((CommunityComment c) => c.postId == postId)
        .toList();

    List<CommunityComment> remote = <CommunityComment>[];
    if (SupabaseService.isReady) {
      try {
        final List<dynamic> rows = await SupabaseService.client
            .from('community_comments')
            .select()
            .eq('post_id', postId)
            .order('created_at');
        remote = rows
            .whereType<Map<String, dynamic>>()
            .map(CommunityComment.fromJson)
            .toList();
      } catch (error) {
        debugPrint('[Eduvora] comment fetch failed: $error');
      }
    }

    final Map<String, CommunityComment> byId = <String, CommunityComment>{};
    for (final CommunityComment c in <CommunityComment>[
      ...remote,
      ...local,
    ]) {
      byId[c.id] = c;
    }

    return byId.values.toList()..sort(
      (CommunityComment a, CommunityComment b) =>
          a.createdAt.compareTo(b.createdAt),
    );
  }

  Future<CommunityComment> addComment({
    required String postId,
    required StudentProfile author,
    required String body,
  }) async {
    final CommunityComment comment = CommunityComment(
      id: _uuid.v4(),
      postId: postId,
      authorId: author.id,
      authorName: author.fullName,
      body: body.trim(),
      createdAt: DateTime.now(),
    );

    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client
            .from('community_comments')
            .insert(comment.toJson());
      } catch (error) {
        debugPrint('[Eduvora] comment insert failed: $error');
      }
    }

    final List<Map<String, dynamic>> cached = LocalStore.instance.readList(
      StoreKeys.communityComments,
    )..add(comment.toJson());
    await LocalStore.instance.writeList(StoreKeys.communityComments, cached);
    return comment;
  }
}
