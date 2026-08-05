import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/institution.dart';

/// A crest for a Nigerian institution.
///
/// Real university crests are trademarks, and Eduvora ships no copy of them.
/// What this draws instead is a generated heraldic shield: the institution's
/// own abbreviation on a colour derived from its name, so UNN, UNILAG, FUTA
/// and ABU each get a mark that is stable, distinct and recognisable at a
/// glance — without an asset bundle of 250 logos, and without claiming to be
/// anybody's official emblem.
///
/// Where a genuine crest is available and the institution has permitted its
/// use, set [logoUrl] (or `Institution.logoUrl`) and that image is shown
/// instead, with the generated shield as the fallback if it fails to load.
class InstitutionCrest extends StatelessWidget {
  const InstitutionCrest({
    super.key,
    required this.abbreviation,
    required this.name,
    this.size = 44,
    this.logoUrl,
    this.onDark = false,
  });

  /// Builds a crest straight from a directory entry.
  factory InstitutionCrest.of(
    Institution institution, {
    double size = 44,
    bool onDark = false,
  }) => InstitutionCrest(
    abbreviation: institution.abbreviation,
    name: institution.name,
    logoUrl: institution.logoUrl,
    size: size,
    onDark: onDark,
  );

  final String abbreviation;
  final String name;
  final double size;
  final String? logoUrl;

  /// Adds a pale rim so the shield still reads against the brand gradient.
  final bool onDark;

  /// A stable colour per institution. The same name always yields the same
  /// hue, so a student's crest never changes between sessions or devices.
  static Color colourFor(String name) {
    final String key = name.trim().toLowerCase();
    if (key.isEmpty) return const Color(0xFF2563EB);

    int hash = 0;
    for (final int unit in key.codeUnits) {
      hash = (hash * 31 + unit) & 0x7FFFFFFF;
    }

    // Deep, saturated, readable against white text. Greens, blues, reds and
    // purples all appear; nothing washes out to pastel or mud.
    final double hue = (hash % 360).toDouble();
    final double saturation = 0.52 + (hash >> 9 & 0xFF) / 255 * 0.24;
    final double lightness = 0.30 + (hash >> 17 & 0xFF) / 255 * 0.10;
    return HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
  }

  /// The letters drawn on the shield. Falls back to initials of the name when
  /// an abbreviation is missing, and never draws more than four characters.
  static String labelFor(String abbreviation, String name) {
    final String abbr = abbreviation.trim();
    if (abbr.isNotEmpty) {
      return abbr.length <= 5 ? abbr.toUpperCase() : abbr.substring(0, 5);
    }

    final List<String> words = name
        .trim()
        .split(RegExp(r'[\s,]+'))
        .where((String w) => w.length > 2)
        .toList();
    if (words.isEmpty) return 'NG';
    return words
        .take(4)
        .map((String w) => w[0].toUpperCase())
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final Widget shield = CustomPaint(
      size: Size(size, size * 1.12),
      painter: _CrestPainter(
        label: labelFor(abbreviation, name),
        colour: colourFor(name),
        onDark: onDark,
      ),
    );

    final String? url = logoUrl?.trim();
    if (url == null || url.isEmpty) return shield;

    return SizedBox(
      width: size,
      height: size * 1.12,
      child: Image.network(
        url,
        fit: BoxFit.contain,
        // A crest that will not load must not leave a hole in the header.
        errorBuilder: (_, _, _) => shield,
        loadingBuilder: (BuildContext _, Widget child, ImageChunkEvent? p) =>
            p == null ? child : shield,
      ),
    );
  }
}

class _CrestPainter extends CustomPainter {
  const _CrestPainter({
    required this.label,
    required this.colour,
    required this.onDark,
  });

  final String label;
  final Color colour;
  final bool onDark;

  /// The classic heater shield: straight shoulders, curved flanks, a point at
  /// the base. Drawn as a fraction of the box so it scales cleanly.
  static Path _shield(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double r = w * 0.10;

    return Path()
      ..moveTo(r, h * 0.06)
      ..lineTo(w - r, h * 0.06)
      ..quadraticBezierTo(w, h * 0.06, w, h * 0.20)
      ..lineTo(w, h * 0.56)
      // The flanks sweep in to the point, which is what makes it read as a
      // crest rather than a rounded rectangle.
      ..cubicTo(w, h * 0.80, w * 0.78, h * 0.93, w * 0.5, h)
      ..cubicTo(w * 0.22, h * 0.93, 0, h * 0.80, 0, h * 0.56)
      ..lineTo(0, h * 0.20)
      ..quadraticBezierTo(0, h * 0.06, r, h * 0.06)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Path shield = _shield(size);
    final HSLColor base = HSLColor.fromColor(colour);

    canvas.drawPath(
      shield,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            base
                .withLightness(math.min(0.62, base.lightness + 0.16))
                .toColor(),
            colour,
          ],
        ).createShader(Offset.zero & size),
    );

    // A chief — the band across the top of a shield — gives the mark some
    // heraldic weight instead of looking like a flat badge.
    canvas.save();
    canvas.clipPath(shield);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.22),
      Paint()..color = Colors.white.withValues(alpha: 0.16),
    );
    canvas.restore();

    canvas.drawPath(
      shield,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * (onDark ? 0.055 : 0.035)
        ..color = onDark
            ? Colors.white.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.55),
    );

    _drawLabel(canvas, size);
  }

  void _drawLabel(Canvas canvas, Size size) {
    // Longer abbreviations step the type down so ATBU and FUOYE fit the same
    // shield as UNN without spilling over the flanks.
    final double fontSize = switch (label.length) {
      <= 2 => size.width * 0.40,
      3 => size.width * 0.33,
      4 => size.width * 0.26,
      _ => size.width * 0.21,
    };

    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          height: 1,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: size.width);

    painter.paint(
      canvas,
      Offset(
        (size.width - painter.width) / 2,
        // Sits just below the chief, which is where a charge belongs.
        size.height * 0.46 - painter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_CrestPainter old) =>
      old.label != label || old.colour != colour || old.onDark != onDark;
}
