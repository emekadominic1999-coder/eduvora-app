import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The Eduvora mark: a graduation cap set in a rounded royal-blue tile with an
/// orange spark, echoing the brand palette.
class EduvoraLogo extends StatelessWidget {
  const EduvoraLogo({
    super.key,
    this.size = 48,
    this.onDark = false,
  });

  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: onDark
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Colors.white, Color(0xFFE0EAFF)],
                    )
                  : AppColours.brandGradient,
              borderRadius: BorderRadius.circular(size * 0.30),
              boxShadow: onDark ? null : AppShadows.card,
            ),
            child: Icon(
              Icons.school_rounded,
              size: size * 0.54,
              color: onDark ? AppColours.primary : Colors.white,
            ),
          ),
          Positioned(
            right: -size * 0.06,
            bottom: -size * 0.04,
            child: Container(
              width: size * 0.34,
              height: size * 0.34,
              decoration: BoxDecoration(
                gradient: AppColours.accentGradient,
                borderRadius: BorderRadius.circular(size * 0.12),
                border: Border.all(
                  color: onDark ? AppColours.primaryDeep : Colors.white,
                  width: size * 0.045,
                ),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: size * 0.16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Logo plus wordmark, used on the landing and sign-in screens.
class EduvoraWordmark extends StatelessWidget {
  const EduvoraWordmark({
    super.key,
    this.logoSize = 42,
    this.onDark = false,
    this.showTagline = false,
  });

  final double logoSize;
  final bool onDark;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final Color textColour = onDark ? Colors.white : AppColours.text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        EduvoraLogo(size: logoSize, onDark: onDark),
        SizedBox(width: logoSize * 0.30),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Eduvora',
              style: TextStyle(
                fontSize: logoSize * 0.55,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
                height: 1.1,
                color: textColour,
              ),
            ),
            if (showTagline)
              Text(
                'Learn together. Graduate stronger.',
                style: TextStyle(
                  fontSize: logoSize * 0.235,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: onDark
                      ? Colors.white.withValues(alpha: 0.78)
                      : AppColours.textMuted,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
