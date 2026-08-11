import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../theme/app_theme.dart';

/// Renders a string that mixes ordinary prose with LaTeX maths.
///
/// Maths is delimited with dollar signs, the usual LaTeX convention:
///
/// ```text
/// Simplify $\frac{x^2 - 9}{x - 3}$ for $x \neq 3$.
/// ```
///
/// Anything outside the delimiters is drawn as normal text, so plain
/// questions with no maths in them are unaffected and cost nothing extra.
/// A malformed expression falls back to showing the raw LaTeX rather than
/// throwing — a broken formula should never take an exam paper down
/// mid-attempt.
class MathText extends StatelessWidget {
  const MathText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.mathScale = 1.12,
  });

  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  /// Formulae are drawn slightly larger than the surrounding prose.
  ///
  /// Maths sets optically smaller than text at the same point size —
  /// subscripts, fraction bars and radicals all shrink — so a small bump
  /// keeps a formula reading at the same weight as the sentence around it.
  final double mathScale;

  /// Matches a balanced `$…$` pair with no dollar sign inside it.
  static final RegExp _maths = RegExp(r'\$([^$]+)\$');

  /// True when [value] contains at least one balanced `$…$` pair, and so
  /// needs the (more expensive) mixed renderer.
  static bool hasMath(String value) => _maths.hasMatch(value);

  /// True when an expression is nothing but a single `\text{...}` wrapper —
  /// the shape every plain prose word takes once the content pipeline wraps
  /// it for LaTeX rendering. Such a span carries no real maths (no
  /// fraction, no exponent, no symbol) — it's an ordinary word that only
  /// happens to be routed through the maths renderer, so it should read at
  /// the same size as the surrounding sentence rather than getting the
  /// size bump real formulae get.
  static bool _isPureText(String expression) {
    final String trimmed = expression.trim();
    if (!trimmed.startsWith(r'\text{') || !trimmed.endsWith('}')) {
      return false;
    }
    return trimmed.split('{').length == trimmed.split('}').length;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle effective = style ?? DefaultTextStyle.of(context).style;

    // The overwhelmingly common case: no maths at all.
    if (!hasMath(text)) {
      return Text(text, style: effective, textAlign: textAlign);
    }

    return Text.rich(
      TextSpan(children: _spans(effective)),
      style: effective,
      textAlign: textAlign,
    );
  }

  List<InlineSpan> _spans(TextStyle style) {
    final List<InlineSpan> spans = <InlineSpan>[];
    int cursor = 0;

    for (final RegExpMatch match in _maths.allMatches(text)) {
      // Any prose sitting before this formula.
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }

      final String expression = match.group(1)!;
      // Formulae stay regular weight even inside bold prose (e.g. a
      // semi-bold question stem) — bold math sets in a different face
      // with thicker strokes throughout, which reads as visual noise
      // rather than emphasis. Plain wrapped words (_isPureText) skip the
      // size bump entirely — it exists to compensate real maths (which
      // sets optically smaller than prose), not to enlarge ordinary text.
      final double scale = _isPureText(expression) ? 1.0 : mathScale;
      final TextStyle mathsStyle = style.copyWith(
        fontSize: (style.fontSize ?? 14) * scale,
        fontWeight: FontWeight.normal,
      );

      spans.add(
        WidgetSpan(
          // Baseline (not middle) alignment: real maths and plain wrapped
          // words both need to sit on the same baseline as the
          // surrounding text, or ascender/descender-heavy words (like
          // "processor" or "protocol") visibly float up or down relative
          // to their neighbours on the same line.
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Math.tex(
            expression,
            textStyle: mathsStyle,
            mathStyle: MathStyle.text,
            onErrorFallback: (FlutterMathException _) => Text(
              '\$$expression\$',
              style: mathsStyle.copyWith(color: AppColours.danger),
            ),
          ),
        ),
      );
      cursor = match.end;
    }

    // Trailing prose, including any unbalanced dollar sign left over.
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return spans;
  }
}
