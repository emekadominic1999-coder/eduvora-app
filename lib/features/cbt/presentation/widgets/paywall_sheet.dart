import 'package:flutter/material.dart';

import '../../../../core/models/cbt.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// What the student picked on the paywall.
enum PaywallChoice { watchAd, singlePaper, coursePack }

/// Offers the ways to unlock CBT access, once a locked paper (or a spent
/// free trial) has been tapped. Returns the chosen [PaywallChoice], or null
/// if the student backed out. [allowAd] adds the optional "watch a short
/// video" choice (only on the Android/iOS apps).
Future<PaywallChoice?> showPaywallSheet(
  BuildContext context,
  CbtSubject subject, {
  bool allowAd = false,
}) {
  return showModalBottomSheet<PaywallChoice>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) =>
        _PaywallSheet(subject: subject, allowAd: allowAd),
  );
}

class _PaywallSheet extends StatelessWidget {
  const _PaywallSheet({required this.subject, required this.allowAd});

  final CbtSubject subject;
  final bool allowAd;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xl + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: 40,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColours.accentSoft,
                borderRadius: AppRadii.sm,
              ),
              child: const Icon(
                Icons.lock_open_rounded,
                size: 18,
                color: AppColours.accent,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Unlock full CBT access',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Every question, every paper, unlimited attempts.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xl),

          if (allowAd) ...<Widget>[
            _PlanCard(
              title: 'Watch a short video',
              body:
                  'Your choice, about 30 seconds. Opens ${subject.name} for '
                  'one sitting.',
              price: 'Free',
              highlighted: false,
              onTap: () => Navigator.of(context).pop(PaywallChoice.watchAd),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          _PlanCard(
            title: 'This paper only',
            body: allowAd
                ? '${subject.name} · unlimited attempts, no ads'
                : '${subject.name} · unlimited attempts, this session',
            price: '₦350',
            highlighted: false,
            onTap: () => Navigator.of(context).pop(PaywallChoice.singlePaper),
          ),
          const SizedBox(height: AppSpacing.md),
          _PlanCard(
            title: 'Build a course pack',
            body:
                'Pick your department, level and semester, then choose up '
                'to 23 units of papers to unlock${allowAd ? ', no ads' : ''}',
            price: '₦2,300',
            highlighted: true,
            badge: 'BEST VALUE',
            onTap: () => Navigator.of(context).pop(PaywallChoice.coursePack),
          ),

          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.shield_outlined,
                size: 14,
                color: AppColours.textFaint,
              ),
              const SizedBox(width: 6),
              Text(
                'Pay by transfer, USSD or card · secured by Paystack',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColours.textFaint),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Independent practice app. Not affiliated with or endorsed by the '
            'University of Nigeria, Nsukka or any school. Practice questions, '
            'not official exam papers.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColours.textFaint),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.body,
    required this.price,
    required this.highlighted,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String body;
  final String price;
  final bool highlighted;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        EduvoraCard(
          onTap: onTap,
          colour: highlighted ? AppColours.accentSoft : AppColours.surface,
          border: Border.all(
            color: highlighted ? AppColours.accent : AppColours.border,
            width: highlighted ? 1.7 : 1,
          ),
          shadows: highlighted ? AppShadows.card : AppShadows.subtle,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      body,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: highlighted
                            ? const Color(0xFF9A3412)
                            : AppColours.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColours.text,
                ),
              ),
            ],
          ),
        ),
        if (badge != null)
          Positioned(
            top: -9,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: AppColours.accent,
                borderRadius: AppRadii.pill,
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
