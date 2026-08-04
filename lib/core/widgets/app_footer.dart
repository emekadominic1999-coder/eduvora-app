import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';
import '../data/nigerian_institutions.dart';
import '../models/institution.dart';
import '../theme/app_theme.dart';
import 'eduvora_logo.dart';

/// The Eduvora footer.
///
/// By design this appears on the landing page **only** — once a student is
/// inside the app, navigation is handled entirely by the bottom bar and no
/// footer is rendered on any other screen.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key, this.onSignIn});

  final VoidCallback? onSignIn;

  static const List<_FooterLink> _product = <_FooterLink>[
    _FooterLink('Academic videos'),
    _FooterLink('CBT practice'),
    _FooterLink('GP calculator'),
    _FooterLink('Materials library'),
  ];

  static const List<_FooterLink> _community = <_FooterLink>[
    _FooterLink('Student community'),
    _FooterLink('Study groups'),
    _FooterLink('Scholarship noticeboard'),
    _FooterLink('Ask Ada'),
  ];

  static const List<_FooterLink> _legal = <_FooterLink>[
    _FooterLink('Privacy policy'),
    _FooterLink('Terms of use'),
    _FooterLink('Community guidelines'),
    _FooterLink('Contact support'),
  ];

  Future<void> _open(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int universities = NigerianInstitutions.countOf(
      InstitutionType.university,
    );
    final int polytechnics = NigerianInstitutions.countOf(
      InstitutionType.polytechnic,
    );
    final int colleges = NigerianInstitutions.countOf(
      InstitutionType.collegeOfEducation,
    );

    return Container(
      width: double.infinity,
      color: AppColours.primaryDeep,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.xxxl,
        AppSpacing.screenPadding,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const EduvoraWordmark(logoSize: 40, onDark: true),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'One home for lectures, materials, practice papers and the people '
            'sitting the same exams as you — across every university, '
            'polytechnic and college of education in Nigeria.',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.white.withValues(alpha: 0.74),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              _FooterStat(value: '$universities', label: 'Universities'),
              _FooterStat(value: '$polytechnics', label: 'Polytechnics'),
              _FooterStat(value: '$colleges', label: 'Colleges of Education'),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool wide = constraints.maxWidth > 520;
              final List<Widget> columns = <Widget>[
                _FooterColumn(title: 'Learn', links: _product),
                _FooterColumn(title: 'Community', links: _community),
                _FooterColumn(title: 'Eduvora', links: _legal),
              ];
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: columns
                      .map((Widget c) => Expanded(child: c))
                      .toList(),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  columns[0],
                  const SizedBox(height: AppSpacing.xl),
                  columns[1],
                  const SizedBox(height: AppSpacing.xl),
                  columns[2],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.xxl),
          Divider(color: Colors.white.withValues(alpha: 0.14), height: 1),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              _FooterIconButton(
                icon: Icons.code_rounded,
                tooltip: 'GitHub — ${AppConfig.githubUser}',
                onTap: () => _open(AppConfig.githubUrl),
              ),
              const SizedBox(width: AppSpacing.sm),
              _FooterIconButton(
                icon: Icons.mail_outline_rounded,
                tooltip: AppConfig.supportEmail,
                onTap: () => _open('mailto:${AppConfig.supportEmail}'),
              ),
              const Spacer(),
              if (onSignIn != null)
                TextButton(
                  onPressed: onSignIn,
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text('Sign in'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '© ${DateTime.now().year} Eduvora · Built for Nigerian students by '
            '${AppConfig.githubUser} · v${AppConfig.version}',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink {
  const _FooterLink(this.label);

  final String label;
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.links});

  final String title;
  final List<_FooterLink> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: AppColours.accent.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...links.map(
          (_FooterLink link) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Text(
              link.label,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.35,
                color: Colors.white.withValues(alpha: 0.72),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterStat extends StatelessWidget {
  const _FooterStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: AppRadii.md,
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$value+',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterIconButton extends StatelessWidget {
  const _FooterIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: AppRadii.sm,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.sm,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
