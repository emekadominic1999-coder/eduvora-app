import 'package:flutter/material.dart';

import '../../../../core/models/community.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/services/community_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'post_detail_screen.dart';

/// Topic channels where students help one another.
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with AutomaticKeepAliveClientMixin {
  static const CommunityRepository _repo = CommunityRepository();

  late Future<List<CommunityPost>> _future;
  CommunityTopic? _topic;
  Set<String> _liked = <String>{};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = _repo.posts();
    _liked = _repo.likedPostIds();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _repo.posts();
      _liked = _repo.likedPostIds();
    });
    await _future;
  }

  Future<void> _toggleLike(CommunityPost post) async {
    await _repo.toggleLike(post);
    setState(() => _liked = _repo.likedPostIds());
  }

  Future<void> _compose() async {
    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return;

    final _Draft? draft = await showModalBottomSheet<_Draft>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) =>
          _ComposeSheet(initialTopic: _topic ?? CommunityTopic.general),
    );
    if (draft == null) return;

    await _repo.createPost(
      author: profile,
      body: draft.body,
      topic: draft.topic,
    );
    await _refresh();
    if (!mounted) return;
    showEduvoraSnack(
      context,
      'Posted. Thank you for adding to the conversation.',
      icon: Icons.forum_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        automaticallyImplyLeading: !widget.embedded,
        title: const Text('Community'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _compose,
        backgroundColor: AppColours.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_rounded),
        label: const Text('New post'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: AppSpacing.md),
          _topicChips(),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: AppColours.primary,
              child: FutureBuilder<List<CommunityPost>>(
                future: _future,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<CommunityPost>> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  List<CommunityPost> posts =
                      snapshot.data ?? <CommunityPost>[];
                  if (_topic != null) {
                    posts = posts
                        .where((CommunityPost p) => p.topic == _topic)
                        .toList();
                  }

                  if (posts.isEmpty) {
                    return ListView(
                      children: <Widget>[
                        EmptyState(
                          icon: Icons.forum_outlined,
                          title: 'Nothing in this channel yet',
                          message:
                              'Be the first to post. A plainly asked question '
                              'helps more people than you would think.',
                          actionLabel: 'Write a post',
                          onAction: _compose,
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      0,
                      AppSpacing.screenPadding,
                      96,
                    ),
                    itemCount: posts.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (BuildContext context, int index) {
                      final CommunityPost post = posts[index];
                      return PostCard(
                        post: post,
                        liked: _liked.contains(post.id),
                        onLike: () => _toggleLike(post),
                        onOpen: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => PostDetailScreen(post: post),
                            ),
                          );
                          if (mounted) await _refresh();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topicChips() {
    final List<CommunityTopic?> values = <CommunityTopic?>[
      null,
      ...CommunityTopic.values,
    ];
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: values.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (BuildContext context, int index) {
          final CommunityTopic? t = values[index];
          final bool selected = _topic == t;
          final Color colour = t?.colour ?? AppColours.primary;
          return Material(
            color: selected ? colour : AppColours.surfaceMuted,
            borderRadius: AppRadii.pill,
            child: InkWell(
              onTap: () => setState(() => _topic = t),
              borderRadius: AppRadii.pill,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      t?.icon ?? Icons.apps_rounded,
                      size: 14,
                      color: selected ? Colors.white : AppColours.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      t?.label ?? 'All channels',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color:
                            selected ? Colors.white : AppColours.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A single post in the feed.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.liked,
    required this.onLike,
    required this.onOpen,
    this.expanded = false,
  });

  final CommunityPost post;
  final bool liked;
  final VoidCallback onLike;
  final VoidCallback onOpen;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      onTap: expanded ? null : onOpen,
      shadows: AppShadows.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              InitialsAvatar(
                initials: _initials(post.authorName),
                size: 40,
                colour: post.topic.colour,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColours.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.authorHeadline.isEmpty
                          ? relativeTime(post.createdAt)
                          : '${post.authorHeadline} · '
                              '${relativeTime(post.createdAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColours.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Pill(
                label: post.topic.label,
                colour: post.topic.colour,
                icon: post.topic.icon,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            post.body,
            maxLines: expanded ? null : 5,
            overflow: expanded ? null : TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColours.text,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              _ActionButton(
                icon: liked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: '${post.likes + (liked ? 1 : 0)}',
                colour: liked ? AppColours.danger : AppColours.textMuted,
                onTap: onLike,
              ),
              const SizedBox(width: AppSpacing.lg),
              _ActionButton(
                icon: Icons.mode_comment_outlined,
                label: '${post.commentCount}',
                colour: AppColours.textMuted,
                onTap: onOpen,
              ),
              const Spacer(),
              if (!expanded)
                TextButton(
                  onPressed: onOpen,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Read replies'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'S';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.colour,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color colour;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.sm,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 18, color: colour),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: colour,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Draft {
  const _Draft(this.body, this.topic);

  final String body;
  final CommunityTopic topic;
}

class _ComposeSheet extends StatefulWidget {
  const _ComposeSheet({required this.initialTopic});

  final CommunityTopic initialTopic;

  @override
  State<_ComposeSheet> createState() => _ComposeSheetState();
}

class _ComposeSheetState extends State<_ComposeSheet> {
  final TextEditingController _body = TextEditingController();
  late CommunityTopic _topic;

  @override
  void initState() {
    super.initState();
    _topic = widget.initialTopic;
  }

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Share with the community',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Questions, advice, encouragement — all welcome.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: CommunityTopic.values.length,
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (BuildContext context, int index) {
                  final CommunityTopic t = CommunityTopic.values[index];
                  final bool selected = _topic == t;
                  return Material(
                    color:
                        selected ? t.colour : AppColours.surfaceMuted,
                    borderRadius: AppRadii.pill,
                    child: InkWell(
                      onTap: () => setState(() => _topic = t),
                      borderRadius: AppRadii.pill,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            t.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : AppColours.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _body,
              maxLines: 6,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'What would you like to say?',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () {
                final String text = _body.text.trim();
                if (text.length < 5) {
                  showEduvoraSnack(
                    context,
                    'Do add a little more so others can help.',
                    isError: true,
                  );
                  return;
                }
                Navigator.of(context).pop(_Draft(text, _topic));
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
