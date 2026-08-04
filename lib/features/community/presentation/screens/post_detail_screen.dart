import 'package:flutter/material.dart';

import '../../../../core/models/community.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/services/community_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'community_screen.dart';

/// A single thread with its replies.
class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.post});

  final CommunityPost post;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  static const CommunityRepository _repo = CommunityRepository();

  final TextEditingController _reply = TextEditingController();
  late Future<List<CommunityComment>> _future;
  Set<String> _liked = <String>{};
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _future = _repo.comments(widget.post.id);
    _liked = _repo.likedPostIds();
  }

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final String body = _reply.text.trim();
    if (body.isEmpty) return;

    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return;

    setState(() => _sending = true);
    try {
      await _repo.addComment(
        postId: widget.post.id,
        author: profile,
        body: body,
      );
      _reply.clear();
      setState(() => _future = _repo.comments(widget.post.id));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _toggleLike() async {
    await _repo.toggleLike(widget.post);
    setState(() => _liked = _repo.likedPostIds());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Thread')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<CommunityComment>>(
              future: _future,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<CommunityComment>> snapshot,
              ) {
                final List<CommunityComment> comments =
                    snapshot.data ?? <CommunityComment>[];

                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  children: <Widget>[
                    PostCard(
                      post: widget.post,
                      liked: _liked.contains(widget.post.id),
                      onLike: _toggleLike,
                      onOpen: () {},
                      expanded: true,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: <Widget>[
                        Text(
                          comments.isEmpty
                              ? 'No replies yet'
                              : '${comments.length} '
                                  '${comments.length == 1 ? 'reply' : 'replies'}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (comments.isEmpty)
                      const EmptyState(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'Be the first to reply',
                        message:
                            'A short, kind answer is worth a great deal to '
                            'whoever asked.',
                        compact: true,
                      )
                    else
                      ...comments.map(
                        (CommunityComment c) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _CommentRow(comment: c),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                );
              },
            ),
          ),
          _composer(),
        ],
      ),
    );
  }

  Widget _composer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColours.surface,
        border: Border(top: BorderSide(color: AppColours.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _reply,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Write a reply…',
                  fillColor: AppColours.surfaceMuted,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 12,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: AppRadii.xl,
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: AppRadii.xl,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: AppRadii.xl,
                    borderSide:
                        BorderSide(color: AppColours.primary, width: 1.4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Material(
              color: AppColours.primary,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _sending ? null : _send,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(11),
                  child: _sending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow({required this.comment});

  final CommunityComment comment;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InitialsAvatar(
            initials: comment.authorName.isEmpty
                ? 'S'
                : comment.authorName.substring(0, 1).toUpperCase(),
            size: 32,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        comment.authorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColours.text,
                        ),
                      ),
                    ),
                    Text(
                      relativeTime(comment.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColours.textFaint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.body,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.55,
                    color: AppColours.text,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
