import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/news_item.dart';
import '../../../../core/services/content_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// Scholarships, admissions, opportunities and academic notices.
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  static const ContentRepository _content = ContentRepository();

  late Future<List<NewsItem>> _future;
  NewsCategory? _category;
  bool _savedOnly = false;
  Set<String> _bookmarks = <String>{};

  @override
  void initState() {
    super.initState();
    _future = _content.news();
    _bookmarks = _content.bookmarkedNewsIds();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _content.news();
      _bookmarks = _content.bookmarkedNewsIds();
    });
    await _future;
  }

  Future<void> _toggleBookmark(NewsItem item) async {
    await _content.toggleNewsBookmark(item.id);
    setState(() => _bookmarks = _content.bookmarkedNewsIds());
  }

  List<NewsItem> _apply(List<NewsItem> source) {
    return source.where((NewsItem n) {
      if (_category != null && n.category != _category) return false;
      if (_savedOnly && !_bookmarks.contains(n.id)) return false;
      return true;
    }).toList()..sort((NewsItem a, NewsItem b) {
      if (a.isFeatured != b.isFeatured) return a.isFeatured ? -1 : 1;
      return b.publishedAt.compareTo(a.publishedAt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('Noticeboard'),
        actions: <Widget>[
          IconButton(
            onPressed: () => setState(() => _savedOnly = !_savedOnly),
            tooltip: _savedOnly ? 'Show everything' : 'Show saved only',
            icon: Icon(
              _savedOnly
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: _savedOnly ? AppColours.accent : null,
            ),
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: AppSpacing.md),
          _categoryChips(),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: AppColours.primary,
              child: FutureBuilder<List<NewsItem>>(
                future: _future,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<List<NewsItem>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final List<NewsItem> items = _apply(
                        snapshot.data ?? <NewsItem>[],
                      );

                      if (items.isEmpty) {
                        final bool noticeboardEmpty =
                            !_savedOnly && (snapshot.data ?? <NewsItem>[]).isEmpty;
                        return ListView(
                          children: <Widget>[
                            EmptyState(
                              icon: _savedOnly
                                  ? Icons.bookmark_border_rounded
                                  : Icons.campaign_outlined,
                              title: _savedOnly
                                  ? 'Nothing saved yet'
                                  : noticeboardEmpty
                                  ? 'No notices yet'
                                  : 'No notices in this category',
                              message: _savedOnly
                                  ? 'Tap the bookmark on any notice to keep it '
                                        'here for later.'
                                  : noticeboardEmpty
                                  ? 'Scholarships, admissions and campus '
                                        'notices will appear here once added.'
                                  : 'Try another category, or pull down to '
                                        'refresh.',
                            ),
                          ],
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPadding,
                          0,
                          AppSpacing.screenPadding,
                          AppSpacing.xxl,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (BuildContext context, int index) {
                          final NewsItem item = items[index];
                          return _NewsCard(
                            item: item,
                            saved: _bookmarks.contains(item.id),
                            onBookmark: () => _toggleBookmark(item),
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

  Widget _categoryChips() {
    final List<NewsCategory?> values = <NewsCategory?>[
      null,
      ...NewsCategory.values,
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
          final NewsCategory? c = values[index];
          final bool selected = _category == c;
          final Color colour = c?.colour ?? AppColours.primary;
          return Material(
            color: selected ? colour : AppColours.surfaceMuted,
            borderRadius: AppRadii.pill,
            child: InkWell(
              onTap: () => setState(() => _category = c),
              borderRadius: AppRadii.pill,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      c?.icon ?? Icons.apps_rounded,
                      size: 14,
                      color: selected ? Colors.white : AppColours.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      c?.label ?? 'All notices',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppColours.textMuted,
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

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.item,
    required this.saved,
    required this.onBookmark,
  });

  final NewsItem item;
  final bool saved;
  final VoidCallback onBookmark;

  void _openDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          maxChildSize: 0.94,
          builder: (BuildContext context, ScrollController controller) {
            return ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Pill(
                      label: item.category.label,
                      colour: item.category.colour,
                      icon: item.category.icon,
                    ),
                    const Spacer(),
                    Text(
                      relativeTime(item.publishedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.source,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColours.primary,
                  ),
                ),
                if (item.hasDeadline) ...<Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: (item.daysLeft ?? 99) <= 7
                          ? AppColours.dangerSoft
                          : AppColours.warningSoft,
                      borderRadius: AppRadii.sm,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.schedule_rounded,
                          size: 18,
                          color: (item.daysLeft ?? 99) <= 7
                              ? AppColours.danger
                              : AppColours.warning,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          item.deadlineLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: (item.daysLeft ?? 99) <= 7
                                ? AppColours.danger
                                : const Color(0xFF854D0E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                Text(
                  item.body.isEmpty ? item.summary : item.body,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.7),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onBookmark();
                        },
                        icon: Icon(
                          saved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          size: 19,
                        ),
                        label: Text(saved ? 'Saved' : 'Save'),
                      ),
                    ),
                    if (item.hasExternalLink) ...<Widget>[
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () async {
                            final Uri uri = Uri.parse(item.link);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          icon: const Icon(Icons.open_in_new_rounded, size: 18),
                          label: Text(
                            item.actionLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int? days = item.daysLeft;
    final bool urgent = days != null && days >= 0 && days <= 7;

    return EduvoraCard(
      onTap: () => _openDetail(context),
      shadows: AppShadows.subtle,
      border: item.isFeatured
          ? Border.all(color: AppColours.accent.withValues(alpha: 0.45))
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: item.category.colour.withValues(alpha: 0.12),
                  borderRadius: AppRadii.sm,
                ),
                child: Icon(
                  item.category.icon,
                  size: 18,
                  color: item.category.colour,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Pill(
                          label: item.category.label,
                          colour: item.category.colour,
                          dense: true,
                        ),
                        if (item.isFeatured) ...<Widget>[
                          const SizedBox(width: 5),
                          const Pill(
                            label: 'Featured',
                            colour: AppColours.accent,
                            dense: true,
                            filled: true,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      relativeTime(item.publishedAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColours.textFaint,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onBookmark,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  size: 20,
                  color: saved ? AppColours.accent : AppColours.textFaint,
                ),
                tooltip: saved ? 'Remove from saved' : 'Save for later',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w700,
              color: AppColours.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.summary,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(height: 1.55),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              const Icon(
                Icons.account_balance_rounded,
                size: 13,
                color: AppColours.textFaint,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  item.source,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColours.textMuted,
                  ),
                ),
              ),
              if (item.hasDeadline)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: urgent
                        ? AppColours.dangerSoft
                        : AppColours.surfaceMuted,
                    borderRadius: AppRadii.pill,
                  ),
                  child: Text(
                    item.deadlineLabel,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: urgent ? AppColours.danger : AppColours.textMuted,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
