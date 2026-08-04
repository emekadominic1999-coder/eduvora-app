import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The Eduvora mark: a graduation cap with a tassel, set in a rounded
/// royal-blue tile, with a four-point spark accent in orange.
///
/// Flattened by hand from the `eduvora_spark` 3D asset (graduation cap:
/// board, band, tassel string and button; AI spark: two crossed elongated
/// diamonds) into a lightweight vector so it needs no 3D renderer and no
/// bundled image asset — just brand-exact colours at any size.
class EduvoraLogo extends StatelessWidget {
  const EduvoraLogo({super.key, this.size = 48, this.onDark = false});

  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final Color markColour = onDark ? AppColours.primary : Colors.white;

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
            child: CustomPaint(
              size: Size(size, size),
              painter: _MortarboardPainter(colour: markColour),
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

/// The graduation-cap glyph: a flat mortarboard board, its band, and a
/// hanging tassel — the same silhouette as the `graduation_cap` node in the
/// source 3D asset (board / band / tassel_string / tassel_button).
class _MortarboardPainter extends CustomPainter {
  const _MortarboardPainter({required this.colour});

  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Paint fill = Paint()
      ..color = colour
      ..style = PaintingStyle.fill;

    // The board: a flat diamond, as a mortarboard top viewed from above.
    final Path board = Path()
      ..moveTo(w * 0.50, h * 0.27)
      ..lineTo(w * 0.77, h * 0.435)
      ..lineTo(w * 0.50, h * 0.60)
      ..lineTo(w * 0.23, h * 0.435)
      ..close();
    canvas.drawPath(board, fill);

    // The band: the cuff sitting beneath the board, against the head.
    final RRect band = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.555),
        width: w * 0.30,
        height: h * 0.16,
      ),
      Radius.circular(w * 0.035),
    );
    canvas.drawRRect(band, Paint()..color = colour.withValues(alpha: 0.92));

    // The tassel: a cord from the board's right point, ending in a button.
    final Offset cordStart = Offset(w * 0.77, h * 0.435);
    final Offset cordEnd = Offset(w * 0.80, h * 0.685);
    final Path cord = Path()
      ..moveTo(cordStart.dx, cordStart.dy)
      ..quadraticBezierTo(w * 0.86, h * 0.55, cordEnd.dx, cordEnd.dy);
    canvas.drawPath(
      cord,
      Paint()
        ..color = colour
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.032
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(cordEnd, w * 0.052, fill);
  }

  @override
  bool shouldRepaint(covariant _MortarboardPainter oldDelegate) =>
      oldDelegate.colour != colour;
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
