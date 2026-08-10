import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The Eduvora mark: an open book on a rounded royal-blue tile, with a
/// four-point spark accent in orange.
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
            child: Padding(
              padding: EdgeInsets.all(size * 0.17),
              child: Image.asset(markAsset, fit: BoxFit.contain),
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
              child: CustomPaint(
                size: Size(size * 0.34, size * 0.34),
                painter: const _SparkPainter(colour: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A four-point spark: two elongated diamonds crossed at right angles,
/// matching the `ai_spark` node (two crossed rectangular meshes) in the
/// source asset.
class _SparkPainter extends CustomPainter {
  const _SparkPainter({required this.colour});

  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset centre = Offset(w * 0.5, h * 0.5);
    final Paint fill = Paint()..color = colour;

    Path spark(double longAxis, double shortAxis) {
      return Path()
        ..moveTo(centre.dx, centre.dy - longAxis)
        ..quadraticBezierTo(
          centre.dx + shortAxis * 0.28,
          centre.dy - shortAxis * 0.28,
          centre.dx + shortAxis,
          centre.dy,
        )
        ..quadraticBezierTo(
          centre.dx + shortAxis * 0.28,
          centre.dy + shortAxis * 0.28,
          centre.dx,
          centre.dy + longAxis,
        )
        ..quadraticBezierTo(
          centre.dx - shortAxis * 0.28,
          centre.dy + shortAxis * 0.28,
          centre.dx - shortAxis,
          centre.dy,
        )
        ..quadraticBezierTo(
          centre.dx - shortAxis * 0.28,
          centre.dy - shortAxis * 0.28,
          centre.dx,
          centre.dy - longAxis,
        )
        ..close();
    }

    canvas.drawPath(spark(h * 0.46, w * 0.15), fill);
  }

  @override
  bool shouldRepaint(covariant _SparkPainter oldDelegate) =>
      oldDelegate.colour != colour;
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
