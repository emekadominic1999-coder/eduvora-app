import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/student_profile.dart';
import '../../../../core/models/study_material.dart';
import '../../../../core/services/content_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'upload_material_screen.dart';

/// The shared resource library for a student's department and level.
class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key, this.embedded = false});

  /// True when hosted inside the bottom-navigation shell.
  final bool embedded;

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen>
    with AutomaticKeepAliveClientMixin {
  static const ContentRepository _content = ContentRepository();

  late Future<List<StudyMaterial>> _future;
  String _query = '';
  MaterialKind? _kind;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<StudyMaterial>> _load() {
    final StudentProfile? profile = sessionController.profile;
    if (profile == null) {
      return Future<List<StudyMaterial>>.value(<StudyMaterial>[]);
    }
    return _content.materials(profile);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  List<StudyMaterial> _apply(List<StudyMaterial> source) {
    final String q = _query.trim().toLowerCase();
    return source.where((StudyMaterial m) {
      if (_kind != null && m.kind != _kind) return false;
      if (q.isEmpty) return true;
      return m.title.toLowerCase().contains(q) ||
          m.courseCode.toLowerCase().contains(q) ||
          m.description.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _openUpload() async {
    final bool? added = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const UploadMaterialScreen()),
    );
    if (added ?? false) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final StudentProfile? profile = sessionController.profile;

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        automaticallyImplyLeading: !widget.embedded,
        title: const Text('Materials'),
        actions: <Widget>[
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openUpload,
        backgroundColor: AppColours.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_rounded),
        label: const Text('Share a resource'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.md,
              AppSpacing.screenPadding,
              AppSpacing.md,
            ),
            child: SearchField(
              hint: 'Search by course code or topic',
              onChanged: (String v) => setState(() => _query = v),
            ),
          ),
          _kindChips(),
          if (profile != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.md,
                AppSpacing.screenPadding,
                AppSpacing.sm,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${profile.department} · ${profile.level}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: AppColours.primary,
              child: FutureBuilder<List<StudyMaterial>>(
                future: _future,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<List<StudyMaterial>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final List<StudyMaterial> items = _apply(
                        snapshot.data ?? <StudyMaterial>[],
                      );

                      if (items.isEmpty) {
                        return ListView(
                          children: <Widget>[
                            EmptyState(
                              icon: Icons.folder_open_rounded,
                              title: 'Nothing here yet',
                              message: _query.isEmpty && _kind == null
                                  ? 'Be the first to share notes with your '
                                        'department. It genuinely helps.'
                                  : 'No resource matches those filters. Try '
                                        'clearing them.',
                              actionLabel: 'Share a resource',
                              onAction: _openUpload,
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
                        itemCount: items.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (BuildContext context, int index) =>
                            _MaterialRow(material: items[index]),
                      );
                    },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kindChips() {
    final List<MaterialKind?> values = <MaterialKind?>[
      null,
      ...MaterialKind.values,
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
          final MaterialKind? k = values[index];
          final bool selected = _kind == k;
          final Color colour = k?.colour ?? AppColours.primary;
          return Material(
            color: selected ? colour : AppColours.surfaceMuted,
            borderRadius: AppRadii.pill,
            child: InkWell(
              onTap: () => setState(() => _kind = k),
              borderRadius: AppRadii.pill,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      k?.icon ?? Icons.apps_rounded,
                      size: 14,
                      color: selected ? Colors.white : AppColours.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      k?.label ?? 'Everything',
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

class _MaterialRow extends StatelessWidget {
  const _MaterialRow({required this.material});

  final StudyMaterial material;

  Future<void> _open(BuildContext context) async {
    if (material.fileUrl.isEmpty) {
      showEduvoraSnack(
        context,
        'No file has been attached to this entry yet.',
        icon: Icons.info_outline_rounded,
      );
      return;
    }
    final Uri uri = Uri.parse(material.fileUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      showEduvoraSnack(context, 'We could not open that file.', isError: true);
    }
  }

  void _details(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.xxl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Pill(
                    label: material.kind.label,
                    colour: material.kind.colour,
                    icon: material.kind.icon,
                  ),
                  const SizedBox(width: 6),
                  Pill(label: material.courseCode),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                material.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                material.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
              const SizedBox(height: AppSpacing.xl),
              _detailRow(context, 'Shared by', material.uploaderName),
              _detailRow(context, 'Department', material.department),
              _detailRow(context, 'Level', material.level),
              _detailRow(
                context,
                'File',
                '${material.extension} · ${material.readableSize}',
              ),
              if (material.createdAt != null)
                _detailRow(context, 'Added', relativeTime(material.createdAt!)),
              const SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _open(context);
                },
                icon: const Icon(Icons.download_rounded, size: 19),
                label: const Text('Open resource'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 96,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColours.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      onTap: () => _details(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: material.kind.colour.withValues(alpha: 0.12),
              borderRadius: AppRadii.sm,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(material.kind.icon, size: 17, color: material.kind.colour),
                const SizedBox(height: 1),
                Text(
                  material.extension,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: material.kind.colour,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  material.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: AppColours.text,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Pill(
                      label: material.kind.label,
                      colour: material.kind.colour,
                      dense: true,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${material.uploaderName} · '
                        '${material.downloads} downloads',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColours.textFaint,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColours.borderStrong,
          ),
        ],
      ),
    );
  }
}
