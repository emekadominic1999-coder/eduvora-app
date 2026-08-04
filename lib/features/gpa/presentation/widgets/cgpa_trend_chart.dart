import 'package:flutter/material.dart';

import '../../../../core/models/gpa.dart';
import '../../../../core/theme/app_theme.dart';

/// GPA per semester as bars, with the cumulative CGPA drawn across as a line.
///
/// Painted by hand rather than pulled from a charting package — it keeps the
/// install size down, which matters on the devices this app is aimed at.
class CgpaTrendChart extends StatelessWidget {
  const CgpaTrendChart({
    super.key,
    required this.semesters,
    required this.cgpa,
  });

  final List<SemesterRecord> semesters;
  final double cgpa;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            _Legend(colour: AppColours.primary, label: 'Semester GPA'),
            const SizedBox(width: AppSpacing.lg),
            _Legend(colour: AppColours.accent, label: 'CGPA', isLine: true),
            const Spacer(),
            Text(
              cgpa.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColours.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 150,
          child: CustomPaint(
            size: Size.infinite,
            painter: _TrendPainter(semesters: semesters, cgpa: cgpa),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: semesters.map((SemesterRecord s) {
            return Expanded(
              child: Text(
                _shortLabel(s.label),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColours.textMuted,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  static String _shortLabel(String label) {
    final List<String> parts = label.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return label.length > 8 ? label.substring(0, 8) : label;
    }
    return parts.map((String p) => p.length > 4 ? p.substring(0, 4) : p).join(' ');
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.colour,
    required this.label,
    this.isLine = false,
  });

  final Color colour;
  final String label;
  final bool isLine;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: isLine ? 14 : 10,
          height: isLine ? 3 : 10,
          decoration: BoxDecoration(
            color: colour,
            borderRadius: BorderRadius.circular(isLine ? 2 : 3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColours.textMuted,
          ),
        ),
      ],
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({required this.semesters, required this.cgpa});

  final List<SemesterRecord> semesters;
  final double cgpa;

  /// The 5-point scale is the vertical axis.
  static const double _max = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (semesters.isEmpty) return;

    final Paint grid = Paint()
      ..color = AppColours.border
      ..strokeWidth = 1;

    // Horizontal guides at 1..5.
    final TextPainter labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    for (int i = 1; i <= 5; i++) {
      final double y = size.height - (i / _max) * size.height;
      canvas.drawLine(Offset(22, y), Offset(size.width, y), grid);

      labelPainter
        ..text = TextSpan(
          text: '$i',
          style: const TextStyle(
            fontSize: 9,
            color: AppColours.textFaint,
          ),
        )
        ..layout();
      labelPainter.paint(canvas, Offset(6, y - labelPainter.height / 2));
    }

    final double chartWidth = size.width - 26;
    final double slot = chartWidth / semesters.length;
    final double barWidth = (slot * 0.46).clamp(8.0, 30.0);

    // Bars.
    for (int i = 0; i < semesters.length; i++) {
      final double gpa = semesters[i].gpa.clamp(0.0, _max);
      final double barHeight = (gpa / _max) * size.height;
      final double centre = 26 + slot * i + slot / 2;

      final Rect rect = Rect.fromLTWH(
        centre - barWidth / 2,
        size.height - barHeight,
        barWidth,
        barHeight <= 0 ? 1 : barHeight,
      );

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: const Radius.circular(5),
          topRight: const Radius.circular(5),
        ),
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[AppColours.primary, Color(0xFF60A5FA)],
          ).createShader(rect),
      );
    }

    // Running CGPA line.
    final Path line = Path();
    int runningUnits = 0;
    int runningPoints = 0;
    final List<Offset> points = <Offset>[];

    for (int i = 0; i < semesters.length; i++) {
      runningUnits += semesters[i].totalUnits;
      runningPoints += semesters[i].totalQualityPoints;
      final double running =
          runningUnits == 0 ? 0 : (runningPoints / runningUnits).clamp(0.0, _max);
      final double centre = 26 + slot * i + slot / 2;
      final double y = size.height - (running / _max) * size.height;
      points.add(Offset(centre, y));
      if (i == 0) {
        line.moveTo(centre, y);
      } else {
        line.lineTo(centre, y);
      }
    }

    canvas.drawPath(
      line,
      Paint()
        ..color = AppColours.accent
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );

    for (final Offset p in points) {
      canvas.drawCircle(p, 4.4, Paint()..color = Colors.white);
      canvas.drawCircle(p, 3.2, Paint()..color = AppColours.accent);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.semesters != semesters || oldDelegate.cgpa != cgpa;
}
