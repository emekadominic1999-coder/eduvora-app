import 'package:flutter/material.dart';

import '../../../../core/data/academic_structure.dart';
import '../../../../core/data/cbt_question_bank.dart';
import '../../../../core/data/nigerian_institutions.dart';
import '../../../../core/models/institution.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_footer.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/eduvora_logo.dart';

/// The public-facing page describing Eduvora.
///
/// This is the **only** screen in the app that carries the footer. It is
/// reached from the "Discover what Eduvora offers" link on the sign-in screen,
/// so a student can read about the app before creating an account.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColours.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0.5,
            leadingWidth: 0,
            leading: const SizedBox.shrink(),
            titleSpacing: AppSpacing.screenPadding,
            title: const EduvoraWordmark(logoSize: 34),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  right: AppSpacing.screenPadding,
                ),
                child: FilledButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    textStyle: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Sign in'),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(child: _Hero(onSignIn: () => Navigator.of(context).maybePop())),
          const SliverToBoxAdapter(child: _Numbers()),
          const SliverToBoxAdapter(child: _Features()),
          const SliverToBoxAdapter(child: _Coverage()),
          const SliverToBoxAdapter(child: _Voices()),
          SliverToBoxAdapter(
            child: _ClosingCta(onSignIn: () => Navigator.of(context).maybePop()),
          ),
          SliverToBoxAdapter(
            child: AppFooter(onSignIn: () => Navigator.of(context).maybePop()),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColours.brandGradient),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.xxxl,
        AppSpacing.screenPadding,
        AppSpacing.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: AppRadii.pill,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 13,
                  color: AppColours.accent,
                ),
                const SizedBox(width: 6),
                Text(
                  'Built for Nigerian higher institutions',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: Colors.white.withValues(alpha: 0.94),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Everything your degree needs,\nin one place.',
            style: text.displayMedium?.copyWith(
              color: Colors.white,
              height: 1.14,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Lecture videos, past questions, CBT practice, a GP calculator '
            'that actually matches your institution, and thousands of '
            'coursemates who are sitting the very same papers.',
            style: text.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          FilledButton(
            onPressed: onSignIn,
            style: FilledButton.styleFrom(
              backgroundColor: AppColours.accent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Get started — it is free'),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: onSignIn,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1.4,
              ),
            ),
            child: const Text('I already have an account'),
          ),
        ],
      ),
    );
  }
}

class _Numbers extends StatelessWidget {
  const _Numbers();

  @override
  Widget build(BuildContext context) {
    final int institutions = NigerianInstitutions.all.length;
    final int departments = AcademicStructure.allDepartments.length;
    final int questions = CbtQuestionBank.totalQuestions;

    return Transform.translate(
      offset: const Offset(0, -26),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        child: EduvoraCard(
          shadows: AppShadows.raised,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _NumberCell(value: '$institutions+', label: 'Institutions'),
              ),
              const _CellDivider(),
              Expanded(
                child: _NumberCell(value: '$departments+', label: 'Departments'),
              ),
              const _CellDivider(),
              Expanded(
                child: _NumberCell(
                  value: '$questions+',
                  label: 'CBT questions',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CellDivider extends StatelessWidget {
  const _CellDivider();

  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 34,
        color: AppColours.border,
      );
}

class _NumberCell extends StatelessWidget {
  const _NumberCell({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: AppColours.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: AppColours.textMuted,
          ),
        ),
      ],
    );
  }
}

class _Features extends StatelessWidget {
  const _Features();

  static const List<_Feature> _items = <_Feature>[
    _Feature(
      icon: Icons.play_circle_fill_rounded,
      colour: AppColours.primary,
      title: 'Academic videos',
      body:
          'Recorded lectures and tutorials filtered to your department and '
          'level, with an in-app player built for small data plans.',
    ),
    _Feature(
      icon: Icons.quiz_rounded,
      colour: AppColours.accent,
      title: 'CBT practice',
      body:
          'Timed multiple-choice papers that behave exactly like the real '
          'thing, then a full review with the reasoning behind every answer.',
    ),
    _Feature(
      icon: Icons.calculate_rounded,
      colour: AppColours.success,
      title: 'GP calculator',
      body:
          'Semester GPA and running CGPA on the standard 5-point scale, with '
          'your degree classification worked out for you.',
    ),
    _Feature(
      icon: Icons.folder_shared_rounded,
      colour: AppColours.info,
      title: 'Materials library',
      body:
          'Lecture notes, past questions, handouts and slides — shared by '
          'students, organised by course code.',
    ),
    _Feature(
      icon: Icons.forum_rounded,
      colour: Color(0xFF7C3AED),
      title: 'Community & chats',
      body:
          'Channels for academics, exam prep, scholarships, careers and '
          'wellbeing, plus study groups for your own course.',
    ),
    _Feature(
      icon: Icons.favorite_rounded,
      colour: Color(0xFFDB2777),
      title: 'Ada, your companion',
      body:
          'A kind guide who knows the app inside out — and who listens when '
          'the semester gets heavy.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.sm,
        AppSpacing.screenPadding,
        AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'What you get',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Six things, done properly, for university, polytechnic and '
            'college of education students alike.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColours.textMuted,
                ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ..._items.map(
            (_Feature f) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: EduvoraCard(
                shadows: AppShadows.subtle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: f.colour.withValues(alpha: 0.11),
                        borderRadius: AppRadii.md,
                      ),
                      child: Icon(f.icon, size: 22, color: f.colour),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            f.title,
                            style:
                                Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            f.body,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(height: 1.55),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  const _Feature({
    required this.icon,
    required this.colour,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color colour;
  final String title;
  final String body;
}

class _Coverage extends StatelessWidget {
  const _Coverage();

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      color: AppColours.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Whichever institution you attend', style: text.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Choose your school, faculty, department and level once. Every '
            'feed in Eduvora then follows you.',
            style: text.bodyMedium?.copyWith(color: AppColours.textMuted),
          ),
          const SizedBox(height: AppSpacing.xl),
          _CoverageRow(
            icon: Icons.account_balance_rounded,
            title: 'Universities',
            count: NigerianInstitutions.countOf(InstitutionType.university),
            examples: 'UNILAG · ABU Zaria · FUTO · OAU · UNIBEN · BUK',
          ),
          const SizedBox(height: AppSpacing.md),
          _CoverageRow(
            icon: Icons.engineering_rounded,
            title: 'Polytechnics',
            count: NigerianInstitutions.countOf(InstitutionType.polytechnic),
            examples: 'YABATECH · KADPOLY · Auchi · Nekede · Ilaro · IMT',
          ),
          const SizedBox(height: AppSpacing.md),
          _CoverageRow(
            icon: Icons.menu_book_rounded,
            title: 'Colleges of Education',
            count: NigerianInstitutions.countOf(
              InstitutionType.collegeOfEducation,
            ),
            examples: 'FCE Zaria · FCET Akoka · FCE Kano · FCE Okene',
          ),
        ],
      ),
    );
  }
}

class _CoverageRow extends StatelessWidget {
  const _CoverageRow({
    required this.icon,
    required this.title,
    required this.count,
    required this.examples,
  });

  final IconData icon;
  final String title;
  final int count;
  final String examples;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColours.background,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColours.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 22, color: AppColours.primary),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Pill(label: '$count listed', dense: true),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  examples,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.5,
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

class _Voices extends StatelessWidget {
  const _Voices();

  static const List<List<String>> _quotes = <List<String>>[
    <String>[
      'I stopped hunting WhatsApp groups for past questions. Everything for my '
          'department is simply there, sorted by course code.',
      'Chinaza · 300 Level, Electrical Engineering',
    ],
    <String>[
      'The GP calculator matched my department’s own computation to two '
          'decimal places. That alone earned it a place on my home screen.',
      'Yusuf · HND 2, Accountancy',
    ],
    <String>[
      'I sat a CBT paper the night before my exam and the review explained the '
          'two questions I had been getting wrong all semester.',
      'Blessing · NCE 2, Integrated Science',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.xxl,
        AppSpacing.screenPadding,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'What students say',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: 186,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: _quotes.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 280,
                  child: EduvoraCard(
                    shadows: AppShadows.subtle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Icon(
                          Icons.format_quote_rounded,
                          color: AppColours.accent,
                          size: 26,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _quotes[index][0],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(height: 1.55, fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          _quotes[index][1],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColours.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ClosingCta extends StatelessWidget {
  const _ClosingCta({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        AppSpacing.xxl,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: AppColours.accentGradient,
          borderRadius: AppRadii.xl,
          boxShadow: AppShadows.raised,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Your next semester starts here',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Create an account in under a minute. No fees, no adverts, and '
              'your work stays on your device even when the network does not.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: onSignIn,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColours.accentDark,
              ),
              child: const Text('Create my free account'),
            ),
          ],
        ),
      ),
    );
  }
}
