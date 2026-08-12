import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The Eduvora mark: an open book on a rounded royal-blue tile.
///
/// The book glyph is a bundled asset (`assets/branding/`), traced from the
/// approved logo artwork rather than hand-painted, so it stays pixel-exact
/// to the brand file at any size.
class EduvoraLogo extends StatelessWidget {
  const EduvoraLogo({super.key, this.size = 48, this.onDark = false});

  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final String markAsset = onDark
        ? 'assets/branding/eduvora_mark_blue.png'
        : 'assets/branding/eduvora_mark_white.png';

    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(size * 0.17),
        child: Image.asset(
          markAsset,
          fit: BoxFit.contain,
          // The mark is a small bundled asset, but on a shaky mobile
          // connection its fetch can still lag behind the rest of the
          // (locally-drawn) splash — without these, Image shows nothing at
          // all until it resolves, or forever if it never does. Fade it in
          // once it lands, and fall back to a plain glyph rather than
          // leaving the tile blank if it doesn't.
          frameBuilder:
              (
                BuildContext context,
                Widget child,
                int? frame,
                bool wasSynchronouslyLoaded,
              ) {
                if (wasSynchronouslyLoaded) return child;
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stack) => Icon(
                Icons.menu_book_rounded,
                size: size * 0.5,
                color: onDark ? AppColours.primary : Colors.white,
              ),
        ),
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
