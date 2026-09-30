import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/community.dart';
import '../../../../core/models/news_item.dart';
import '../../../../core/services/community_repository.dart';
import '../../../../core/services/content_repository.dart';
import '../../../../core/services/local_store.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// Where a category's post lands in the Community channels.
extension on NewsCategory {
  CommunityTopic get communityTopic => switch (this) {
    NewsCategory.scholarship => CommunityTopic.scholarships,
    NewsCategory.admission ||
    NewsCategory.academic => CommunityTopic.academics,
    NewsCategory.opportunity => CommunityTopic.careers,
    NewsCategory.competition => CommunityTopic.general,
  };
}

/// Owner-only: post a scholarship, admission notice, opportunity or academic
/// notice straight into the Noticeboard, and manage what is already there.
///
/// The screen itself only decides whether to *show* this entry point (see
/// where it is opened from); the real gate is server-side — see
/// `supabase/OWNER_NEWS_POSTING.sql` — so this never becomes a way for
/// anyone else to post.
class PostNewsScreen extends StatefulWidget {
  const PostNewsScreen({super.key});

  @override
  State<PostNewsScreen> createState() => _PostNewsScreenState();
}

class _PostNewsScreenState extends State<PostNewsScreen> {
  static const ContentRepository _content = ContentRepository();
  static const CommunityRepository _community = CommunityRepository();
  static const Uuid _uuid = Uuid();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _summary = TextEditingController();
  final TextEditingController _source = TextEditingController(
    text: 'Eduvora',
  );
  final TextEditingController _link = TextEditingController();

  NewsCategory _category = NewsCategory.scholarship;
  DateTime? _deadline;
  bool _featured = false;
  bool _posting = false;
  PlatformFile? _image;

  late Future<List<NewsItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _content.news();
    final bool restored = _restoreDraft();
    // Compiling a real post often means going back and forth to a browser
    // or WhatsApp to copy the next detail, and switching away for that can
    // let a mobile browser (or a low-end phone's OS) reclaim this tab and
    // reload the whole app from scratch. Saving every keystroke means the
    // draft is still there when that happens, instead of everything typed
    // so far quietly vanishing.
    _title.addListener(_saveDraft);
    _summary.addListener(_saveDraft);
    _source.addListener(_saveDraft);
    _link.addListener(_saveDraft);
    if (restored) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showEduvoraSnack(
            context,
            'Picked up where you left off.',
            icon: Icons.history_rounded,
          );
        }
      });
    }
  }

  /// Returns true when there was an unfinished draft worth telling the
  /// owner about (not just an empty one from a previous, already-posted
  /// update).
  bool _restoreDraft() {
    final Map<String, dynamic>? draft = LocalStore.instance.readMap(
      StoreKeys.postNewsDraft,
    );
    if (draft == null) return false;
    _title.text = (draft['title'] as String?) ?? '';
    _summary.text = (draft['summary'] as String?) ?? '';
    _source.text = (draft['source'] as String?) ?? 'Eduvora';
    _link.text = (draft['link'] as String?) ?? '';
    _category = NewsCategory.fromName(draft['category'] as String?);
    _deadline = DateTime.tryParse((draft['deadline'] as String?) ?? '');
    _featured = draft['featured'] == true;
    return _title.text.trim().isNotEmpty || _summary.text.trim().isNotEmpty;
  }

  void _saveDraft() {
    unawaited(
      LocalStore.instance.writeMap(StoreKeys.postNewsDraft, <String, dynamic>{
        'title': _title.text,
        'summary': _summary.text,
        'source': _source.text,
        'link': _link.text,
        'category': _category.name,
        'deadline': _deadline?.toIso8601String(),
        'featured': _featured,
      }),
    );
  }

  Future<void> _clearDraft() => LocalStore.instance.remove(
    StoreKeys.postNewsDraft,
  );

  @override
  void dispose() {
    _title.dispose();
    _summary.dispose();
    _source.dispose();
    _link.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now.add(const Duration(days: 14)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
      _saveDraft();
    }
  }

  Future<void> _pickImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.image,
    );
    final List<PlatformFile> files = result?.files ?? const <PlatformFile>[];
    if (files.isNotEmpty) setState(() => _image = files.first);
  }

  Widget _imagePicker() {
    final Uint8List? bytes = _image?.bytes;
    if (bytes == null) {
      return OutlinedButton.icon(
        onPressed: _pickImage,
        icon: const Icon(Icons.image_outlined, size: 18),
        label: const Text('Add a picture (optional)'),
      );
    }
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: AppRadii.sm,
          child: Image.memory(
            bytes,
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: Material(
            color: Colors.black.withValues(alpha: 0.55),
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: () => setState(() => _image = null),
              icon: const Icon(Icons.close_rounded, size: 18),
              color: Colors.white,
              tooltip: 'Remove picture',
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _post() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final String link = _link.text.trim();
    if (link.isNotEmpty &&
        !(link.startsWith('http://') || link.startsWith('https://'))) {
      showEduvoraSnack(
        context,
        'The link needs to start with http:// or https://',
        isError: true,
      );
      return;
    }

    setState(() => _posting = true);
    try {
      String imageUrl = '';
      final PlatformFile? image = _image;
      if (image != null && image.bytes != null) {
        try {
          imageUrl = await _content.uploadNoticeImage(
            image.bytes!,
            image.name,
          );
        } catch (error) {
          debugPrint('Notice picture upload failed: $error');
          if (mounted) {
            showEduvoraSnack(
              context,
              'The picture did not upload ($error), so this went up as text only.',
              isError: true,
            );
          }
        }
      } else if (image != null && mounted) {
        showEduvoraSnack(
          context,
          'The picture could not be read from your device, so this went up as text only.',
          isError: true,
        );
      }

      final String category = _category.label;
      final String title = _title.text.trim();
      final String summary = _summary.text.trim();

      await _content.createNews(
        NewsItem(
          id: _uuid.v4(),
          title: title,
          summary: summary,
          category: _category,
          source: _source.text.trim().isEmpty ? 'Eduvora' : _source.text.trim(),
          publishedAt: DateTime.now(),
          link: link,
          deadline: _deadline,
          isFeatured: _featured,
          imageUrl: imageUrl,
        ),
      );
      if (!mounted) return;

      // Cross-post to Community too, pinned to the top, so students see it
      // there without the owner doing anything extra.
      String communityWarning = '';
      try {
        final StringBuffer body = StringBuffer('📢 $title\n\n$summary');
        if (link.isNotEmpty) body.write('\n\nApply: $link');
        if (_deadline != null) {
          body.write(
            '\n\nCloses: ${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
          );
        }
        await _community.createAnnouncement(
          authorName: sessionController.profile?.fullName.isNotEmpty == true
              ? sessionController.profile!.fullName
              : 'Eduvora',
          body: body.toString(),
          topic: _category.communityTopic,
          imageUrl: imageUrl,
        );
      } catch (error) {
        communityWarning = ' It did not reach Community, though — check your '
            'connection and try posting again if that matters for this one.';
      }
      if (!mounted) return;

      showEduvoraSnack(
        context,
        'Posted. Students will see it in the Noticeboard, under '
        '$category, and pinned at the top of Community.$communityWarning',
        icon: Icons.campaign_rounded,
        isError: communityWarning.isNotEmpty,
      );
      _title.clear();
      _summary.clear();
      _link.clear();
      setState(() {
        _deadline = null;
        _featured = false;
        _image = null;
        _future = _content.news();
      });
      await _clearDraft();
    } catch (error) {
      if (mounted) {
        showEduvoraSnack(
          context,
          'Could not post that. Please check your connection and try again.',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  Future<void> _delete(NewsItem item) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Remove "${item.title}"?'),
        content: const Text(
          'Students will no longer see this in the Noticeboard.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColours.danger),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (!(confirm ?? false)) return;

    try {
      await _content.deleteNews(item.id);
      if (mounted) setState(() => _future = _content.news());
    } catch (_) {
      if (mounted) {
        showEduvoraSnack(context, 'Could not remove that.', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('Post an update'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.lg,
                AppSpacing.screenPadding,
                0,
              ),
              child: EduvoraCard(
                shadows: AppShadows.subtle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Every post goes straight to the Noticeboard, sorted '
                      'into its category automatically — students filter by '
                      'the same categories you pick below.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<NewsCategory>(
                      initialValue: _category,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: NewsCategory.values
                          .map(
                            (NewsCategory c) => DropdownMenuItem<NewsCategory>(
                              value: c,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(c.icon, size: 17, color: c.colour),
                                  const SizedBox(width: 8),
                                  Text(c.label),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (NewsCategory? c) {
                        setState(() => _category = c ?? _category);
                        _saveDraft();
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _title,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'e.g. MTN Foundation Scholarship 2026',
                      ),
                      validator: (String? v) => (v == null || v.trim().isEmpty)
                          ? 'Give it a title'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _summary,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Details',
                        hintText:
                            'Who it is for, how much, and how to apply.',
                        alignLabelWithHint: true,
                      ),
                      validator: (String? v) => (v == null || v.trim().isEmpty)
                          ? 'Add a few details'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _link,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Link (optional)',
                        hintText: 'https://…',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _source,
                      decoration: const InputDecoration(
                        labelText: 'Source',
                        hintText: 'Eduvora',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _imagePicker(),
                    const SizedBox(height: AppSpacing.md),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.event_rounded,
                        color: AppColours.textMuted,
                      ),
                      title: Text(
                        _deadline == null
                            ? 'No deadline (rolling)'
                            : 'Closes ${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
                        style: const TextStyle(fontSize: 13.5),
                      ),
                      trailing: TextButton(
                        onPressed: _pickDeadline,
                        child: Text(_deadline == null ? 'Set' : 'Change'),
                      ),
                      onTap: _pickDeadline,
                    ),
                    if (_deadline != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            setState(() => _deadline = null);
                            _saveDraft();
                          },
                          child: const Text('Clear deadline'),
                        ),
                      ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _featured,
                      onChanged: (bool v) {
                        setState(() => _featured = v);
                        _saveDraft();
                      },
                      title: const Text(
                        'Feature at the top of the Noticeboard',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _posting ? null : _post,
                        icon: _posting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.campaign_rounded, size: 19),
                        label: Text(_posting ? 'Posting…' : 'Post to Noticeboard'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SectionHeader(
            title: 'Posted so far',
            subtitle: 'Tap the bin to take one down',
          ),
          FutureBuilder<List<NewsItem>>(
            future: _future,
            builder:
                (BuildContext context, AsyncSnapshot<List<NewsItem>> snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final List<NewsItem> items = snap.data ?? <NewsItem>[];
                  if (items.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      child: Text(
                        'Nothing posted yet.',
                        style: TextStyle(color: AppColours.textMuted),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: Column(
                      children: items
                          .map(
                            (NewsItem item) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm,
                              ),
                              child: EduvoraCard(
                                shadows: AppShadows.subtle,
                                child: Row(
                                  children: <Widget>[
                                    item.hasImage
                                        ? ClipRRect(
                                            borderRadius: AppRadii.sm,
                                            child: Image.network(
                                              item.imageUrl,
                                              width: 34,
                                              height: 34,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, _, _) => Icon(
                                                    item.category.icon,
                                                    size: 17,
                                                    color: item.category.colour,
                                                  ),
                                            ),
                                          )
                                        : Container(
                                            width: 34,
                                            height: 34,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: item.category.colour
                                                  .withValues(alpha: 0.12),
                                              borderRadius: AppRadii.sm,
                                            ),
                                            child: Icon(
                                              item.category.icon,
                                              size: 17,
                                              color: item.category.colour,
                                            ),
                                          ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            item.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.category.label,
                                            style: const TextStyle(
                                              fontSize: 11.5,
                                              color: AppColours.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _delete(item),
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 19,
                                        color: AppColours.textFaint,
                                      ),
                                      tooltip: 'Remove',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
          ),
        ],
      ),
    );
  }
}
