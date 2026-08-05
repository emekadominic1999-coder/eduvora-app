import 'package:flutter/material.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../chats/presentation/screens/assistant_screen.dart';

/// The dashboard's feature grid — every headline capability, one tap away.
class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  static const List<_Action> _actions = <_Action>[
    _Action(
      label: 'Academic\nvideos',
      icon: Icons.play_circle_fill_rounded,
      colour: AppColours.primary,
      route: AppRouter.videos,
    ),
    _Action(
      label: 'CBT exam\npractice',
      icon: Icons.quiz_rounded,
      colour: AppColours.accent,
      route: AppRouter.cbt,
    ),
    _Action(
      label: 'Course\noutline',
      icon: Icons.list_alt_rounded,
      colour: Color(0xFF0891B2),
      route: AppRouter.courses,
    ),
    _Action(
      label: 'Study\ngroups',
      icon: Icons.groups_rounded,
      colour: Color(0xFF2563EB),
      route: AppRouter.groups,
    ),
    _Action(
      label: 'Class\nlists',
      icon: Icons.fact_check_rounded,
      colour: Color(0xFFEA580C),
      route: AppRouter.classLists,
    ),
    _Action(
      label: 'GP\ncalculator',
      icon: Icons.calculate_rounded,
      colour: AppColours.success,
      route: AppRouter.gpa,
    ),
    _Action(
      label: 'Materials\n& notes',
      icon: Icons.folder_shared_rounded,
      colour: AppColours.info,
      route: AppRouter.materials,
    ),
    _Action(
      label: 'Upload a\nresource',
      icon: Icons.cloud_upload_rounded,
      colour: Color(0xFF7C3AED),
      route: AppRouter.upload,
    ),
    _Action(
      label: 'Student\ncommunity',
      icon: Icons.forum_rounded,
      colour: Color(0xFFDB2777),
      route: AppRouter.community,
    ),
    _Action(
      label: 'Scholarship\nnews',
      icon: Icons.workspace_premium_rounded,
      colour: Color(0xFFCA8A04),
      route: AppRouter.news,
    ),
    _Action(
      label: 'Ask\nAda',
      icon: Icons.auto_awesome_rounded,
      colour: Color(0xFF0D9488),
      route: AppRouter.assistant,
    ),
  ];

  void _go(BuildContext context, String route) {
    if (route == AppRouter.assistant) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const AssistantScreen()));
      return;
    }
    AppRouter.go(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.74,
        ),
        itemCount: _actions.length,
        itemBuilder: (BuildContext context, int index) {
          final _Action action = _actions[index];
          return EduvoraCard(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: AppSpacing.md,
            ),
            shadows: AppShadows.subtle,
            onTap: () => _go(context, action.route),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: action.colour.withValues(alpha: 0.12),
                    borderRadius: AppRadii.sm,
                  ),
                  child: Icon(action.icon, size: 20, color: action.colour),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  action.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 10.5,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: AppColours.text,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Action {
  const _Action({
    required this.label,
    required this.icon,
    required this.colour,
    required this.route,
  });

  final String label;
  final IconData icon;
  final Color colour;
  final String route;
}
