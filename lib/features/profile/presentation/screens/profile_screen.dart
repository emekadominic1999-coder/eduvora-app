import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/academic_structure.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/models/study_material.dart';
import '../../../../core/services/content_repository.dart';
import '../../../../core/services/study_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../auth/presentation/screens/auth_screen.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';

/// Academic identity, activity summary and account controls.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  static const StudyRepository _study = StudyRepository();
  static const ContentRepository _content = ContentRepository();

  @override
  bool get wantKeepAlive => true;

  Future<void> _editAcademic() async {
    final bool? changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => const OnboardingScreen(editing: true),
      ),
    );
    if ((changed ?? false) && mounted) setState(() {});
  }

  Future<void> _signOut() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Sign out of Eduvora?'),
        content: const Text(
          'Your saved semesters, CBT history and bookmarks stay on this '
          'device, so signing back in picks up where you left off.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay signed in'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColours.danger),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (!(confirm ?? false)) return;

    await sessionController.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const AuthScreen()),
      (Route<dynamic> _) => false,
    );
  }

  Future<void> _openGithub() async {
    final Uri uri = Uri.parse(AppConfig.githubUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListenableBuilder(
      listenable: sessionController,
      builder: (BuildContext context, _) {
        final StudentProfile? profile = sessionController.profile;
        if (profile == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: AppColours.background,
          appBar: AppBar(
            automaticallyImplyLeading: !widget.embedded,
            title: const Text('Profile'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: AppColours.border),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: <Widget>[
              _identityCard(profile),
              _statsRow(),
              const SectionHeader(title: 'Academic details'),
              _academicCard(profile),
              const SectionHeader(title: 'Your contributions'),
              _contributions(profile),
              const SectionHeader(title: 'Account'),
              _accountCard(),
              const SectionHeader(title: 'About Eduvora'),
              _aboutCard(),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Text(
                  'Eduvora v${AppConfig.version} · '
                  'Built by ${AppConfig.githubUser}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
      },
    );
  }

  Widget _identityCard(StudentProfile profile) {
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
        child: Row(
          children: <Widget>[
            InitialsAvatar(
              initials: profile.initials,
              size: 64,
              colour: Colors.white,
              imageUrl: profile.avatarUrl,
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    profile.fullName.isEmpty ? 'Student' : profile.fullName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    profile.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.white.withValues(alpha: 0.78),
                    ),
                  ),
                  if (profile.matricNumber.isNotEmpty) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: AppRadii.pill,
                      ),
                      child: Text(
                        profile.matricNumber,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statsRow() {
    final double cgpa = _study.cumulativeGpa();
    final int papers = _study.attempts().length;
    final int units = _study.totalUnitsPassed();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: StatTile(
              label: 'Cumulative GPA',
              value: cgpa > 0 ? cgpa.toStringAsFixed(2) : '—',
              icon: Icons.school_rounded,
              colour: AppColours.success,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: StatTile(
              label: 'CBT papers sat',
              value: '$papers',
              icon: Icons.quiz_rounded,
              colour: AppColours.accent,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: StatTile(
              label: 'Units passed',
              value: '$units',
              icon: Icons.verified_rounded,
              colour: AppColours.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _academicCard(StudentProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: EduvoraCard(
        shadows: AppShadows.subtle,
        child: Column(
          children: <Widget>[
            _row(
              icon: profile.institutionType.icon,
              label: 'Institution',
              value: profile.institutionName.isEmpty
                  ? 'Not set'
                  : profile.institutionName,
              trailing: profile.institutionState.isEmpty
                  ? null
                  : profile.institutionState,
            ),
            const Divider(height: AppSpacing.xl),
            _row(
              icon: Icons.apartment_rounded,
              label: AcademicStructure.facultyLabelFor(profile.institutionType),
              value: profile.faculty.isEmpty ? 'Not set' : profile.faculty,
            ),
            const Divider(height: AppSpacing.xl),
            _row(
              icon: Icons.workspaces_rounded,
              label: 'Department',
              value: profile.department.isEmpty
                  ? 'Not set'
                  : profile.department,
            ),
            const Divider(height: AppSpacing.xl),
            _row(
              icon: Icons.stairs_rounded,
              label: 'Level',
              value: profile.level.isEmpty ? 'Not set' : profile.level,
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: _editAcademic,
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text('Edit academic details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contributions(StudentProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: FutureBuilder<List<StudyMaterial>>(
        future: _content.myUploads(profile),
        builder:
            (
              BuildContext context,
              AsyncSnapshot<List<StudyMaterial>> snapshot,
            ) {
              final List<StudyMaterial> mine =
                  snapshot.data ?? <StudyMaterial>[];
              if (mine.isEmpty) {
                return EduvoraCard(
                  shadows: AppShadows.subtle,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColours.accent.withValues(alpha: 0.12),
                          borderRadius: AppRadii.sm,
                        ),
                        child: const Icon(
                          Icons.volunteer_activism_rounded,
                          size: 20,
                          color: AppColours.accent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'You have not shared a resource yet. Even one set of '
                          'notes helps the person coming behind you.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(height: 1.55),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: mine
                    .take(5)
                    .map(
                      (StudyMaterial m) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: EduvoraCard(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          shadows: AppShadows.subtle,
                          child: Row(
                            children: <Widget>[
                              Icon(m.kind.icon, size: 19, color: m.kind.colour),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Text(
                                  m.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColours.text,
                                  ),
                                ),
                              ),
                              Pill(label: m.courseCode, dense: true),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
      ),
    );
  }

  Widget _accountCard() {
    final bool connected = sessionController.usingBackend;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: EduvoraCard(
        shadows: AppShadows.subtle,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: (connected ? AppColours.success : AppColours.info)
                      .withValues(alpha: 0.12),
                  borderRadius: AppRadii.sm,
                ),
                child: Icon(
                  connected
                      ? Icons.cloud_done_rounded
                      : Icons.offline_bolt_rounded,
                  size: 19,
                  color: connected ? AppColours.success : AppColours.info,
                ),
              ),
              title: Text(sessionController.backendLabel),
              subtitle: Text(
                connected
                    ? 'Signed in and syncing with the Eduvora backend.'
                    : 'Running entirely on this device. Everything works, and '
                          'nothing is lost.',
              ),
              isThreeLine: !connected,
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColours.danger.withValues(alpha: 0.12),
                  borderRadius: AppRadii.sm,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 19,
                  color: AppColours.danger,
                ),
              ),
              title: const Text(
                'Sign out',
                style: TextStyle(color: AppColours.danger),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppColours.borderStrong,
              ),
              onTap: _signOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboutCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: EduvoraCard(
        shadows: AppShadows.subtle,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.favorite_rounded, size: 20),
              title: const Text('Ada, your companion'),
              subtitle: const Text(
                'Warm, patient help with the app — and a listening ear.',
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: const Icon(Icons.code_rounded, size: 20),
              title: const Text('Source and issues'),
              subtitle: Text('github.com/${AppConfig.githubUser}'),
              trailing: const Icon(Icons.open_in_new_rounded, size: 17),
              onTap: _openGithub,
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: const Icon(Icons.mail_outline_rounded, size: 20),
              title: const Text('Contact support'),
              subtitle: const Text(AppConfig.supportEmail),
              trailing: const Icon(Icons.open_in_new_rounded, size: 17),
              onTap: () async {
                final Uri uri = Uri.parse('mailto:${AppConfig.supportEmail}');
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _row({
    required IconData icon,
    required String label,
    required String value,
    String? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 19, color: AppColours.textMuted),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColours.textMuted,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: AppColours.text,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) Pill(label: trailing, dense: true),
      ],
    );
  }
}
