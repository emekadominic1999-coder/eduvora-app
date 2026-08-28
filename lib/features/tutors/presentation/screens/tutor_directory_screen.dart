import 'package:flutter/material.dart';

import '../../../../core/models/cbt.dart';
import '../../../../core/models/tutor.dart';
import '../../../../core/services/cbt_repository.dart';
import '../../../../core/services/tutor_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../widgets/tutor_card.dart';
import 'become_tutor_screen.dart';
import 'tutor_profile_screen.dart';
import 'tutor_sessions_screen.dart';

/// Browse verified tutors, optionally narrowed to one paper.
///
/// [initialSubjectId] lets the CBT result screen drop a student straight
/// into "tutors who can help with the paper you just struggled on".
class TutorDirectoryScreen extends StatefulWidget {
  const TutorDirectoryScreen({super.key, this.initialSubjectId = ''});

  final String initialSubjectId;

  @override
  State<TutorDirectoryScreen> createState() => _TutorDirectoryScreenState();
}

class _TutorDirectoryScreenState extends State<TutorDirectoryScreen> {
  static const TutorRepository _tutors = TutorRepository();
  static const CbtRepository _cbt = CbtRepository();

  late String _subjectId = widget.initialSubjectId;
  late Future<_DirectoryData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_DirectoryData> _load() async {
    final List<Tutor> tutors = await _tutors.browse(subjectId: _subjectId);
    final List<CbtSubject> subjects = await _cbt.all();
    final Tutor? mine = await _tutors.myTutorProfile();
    return _DirectoryData(tutors: tutors, subjects: subjects, myProfile: mine);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  void _filterBy(String subjectId) {
    setState(() {
      _subjectId = subjectId;
      _future = _load();
    });
  }

  Future<void> _openProfile(Tutor tutor) async {
    final bool? booked = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) =>
            TutorProfileScreen(tutor: tutor, preselectedSubjectId: _subjectId),
      ),
    );
    if ((booked ?? false) && mounted) _refresh();
  }

  Future<void> _openBecomeTutor(Tutor? existing) async {
    final bool? changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BecomeTutorScreen(existing: existing),
      ),
    );
    if ((changed ?? false) && mounted) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('Find a tutor'),
        actions: <Widget>[
          IconButton(
            tooltip: 'My sessions',
            icon: const Icon(Icons.event_note_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const TutorSessionsScreen(),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColours.primary,
        child: FutureBuilder<_DirectoryData>(
          future: _future,
          builder:
              (BuildContext context, AsyncSnapshot<_DirectoryData> snapshot) {
                final _DirectoryData? data = snapshot.data;
                final bool loading =
                    snapshot.connectionState == ConnectionState.waiting;

                return ListView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  children: <Widget>[
                    _Intro(
                      myProfile: data?.myProfile,
                      onBecomeTutor: () => _openBecomeTutor(data?.myProfile),
                    ),
                    if (data != null && data.subjects.isNotEmpty)
                      _SubjectFilter(
                        subjects: data.subjects,
                        selectedId: _subjectId,
                        onChanged: _filterBy,
                      ),
                    if (loading && data == null)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (data == null || data.tutors.isEmpty)
                      EmptyState(
                        icon: Icons.person_search_rounded,
                        title: 'No tutors yet',
                        message: _subjectId.isEmpty
                            ? 'Nobody has been verified to tutor yet. If you '
                                  'know a course well, you could be the first.'
                            : 'No verified tutor teaches this paper yet — try '
                                  'another course, or become the first to '
                                  'teach it.',
                        actionLabel: 'Become a tutor',
                        onAction: () => _openBecomeTutor(data?.myProfile),
                        compact: true,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        child: Column(
                          children: data.tutors
                              .map(
                                (Tutor t) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md,
                                  ),
                                  child: TutorCard(
                                    tutor: t,
                                    highlightSubjectId: _subjectId,
                                    onTap: () => _openProfile(t),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                  ],
                );
              },
        ),
      ),
    );
  }
}

class _DirectoryData {
  const _DirectoryData({
    required this.tutors,
    required this.subjects,
    required this.myProfile,
  });

  final List<Tutor> tutors;
  final List<CbtSubject> subjects;
  final Tutor? myProfile;
}

class _Intro extends StatelessWidget {
  const _Intro({required this.myProfile, required this.onBecomeTutor});

  final Tutor? myProfile;
  final VoidCallback onBecomeTutor;

  @override
  Widget build(BuildContext context) {
    final Tutor? mine = myProfile;
    final bool isPending = mine?.status == TutorStatus.pending;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: AppColours.brandGradient,
          borderRadius: AppRadii.lg,
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(
                  Icons.verified_user_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    mine == null
                        ? 'Learn from someone who has proved it'
                        : isPending
                        ? 'Your application is under review'
                        : 'You teach on Eduvora',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.96),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              mine == null
                  ? 'Every tutor here has sat the same CBT paper you are '
                        'revising and scored '
                        '${TutorRepository.minCbtScore}% or above on it, or '
                        'was approved by hand. Book a session, pay in the '
                        'app, rate them afterwards.'
                  : isPending
                  ? 'You applied through manual review — an operator will '
                        'approve or reject it directly. You will show up in '
                        'the directory once that happens.'
                  : 'Students can find you for the papers you have been '
                        'verified on. Keep your rating up and you will appear '
                        'higher in the list.',
              style: TextStyle(
                fontSize: 13,
                height: 1.55,
                color: Colors.white.withValues(alpha: 0.78),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onBecomeTutor,
              icon: Icon(
                mine == null
                    ? Icons.school_rounded
                    : isPending
                    ? Icons.hourglass_top_rounded
                    : Icons.edit_rounded,
                size: 18,
              ),
              label: Text(
                mine == null
                    ? 'Become a tutor'
                    : isPending
                    ? 'View my application'
                    : 'Edit my tutoring',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColours.primaryDeep,
                minimumSize: const Size(0, 42),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectFilter extends StatelessWidget {
  const _SubjectFilter({
    required this.subjects,
    required this.selectedId,
    required this.onChanged,
  });

  final List<CbtSubject> subjects;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionHeader(
          title: 'Filter by course',
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.xl,
            AppSpacing.screenPadding,
            AppSpacing.sm,
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            children: <Widget>[
              _Chip(
                label: 'All courses',
                selected: selectedId.isEmpty,
                onTap: () => onChanged(''),
              ),
              ...subjects.map(
                (CbtSubject s) => _Chip(
                  label: s.name,
                  selected: s.id == selectedId,
                  onTap: () => onChanged(s.id),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColours.primaryTint,
        labelStyle: TextStyle(
          fontSize: 12.5,
          color: selected ? AppColours.primary : AppColours.text,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected ? AppColours.primary : AppColours.border,
        ),
      ),
    );
  }
}
