import 'package:eduvora/core/widgets/math_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('MathText detection', () {
    test('plain prose needs no maths rendering', () {
      expect(MathText.hasMath('Simplify the expression below.'), isFalse);
    });

    test('a balanced pair is detected', () {
      expect(MathText.hasMath(r'Simplify $2^3 \times 2^5$'), isTrue);
    });

    test('a lone dollar sign is not treated as maths', () {
      expect(
        MathText.hasMath(r'The bursary is worth $500 per session'),
        isFalse,
        reason: 'a single unbalanced delimiter must stay as prose',
      );
    });

    test('several formulae in one sentence are detected', () {
      expect(MathText.hasMath(r'If $x = 2$ then $x^2 = 4$'), isTrue);
    });
  });

  group('MathText rendering', () {
    testWidgets('plain prose renders as an ordinary Text widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(const MathText('No maths here at all.')));
      await tester.pumpAndSettle();

      expect(find.text('No maths here at all.'), findsOneWidget);
    });

    testWidgets('a currency amount is left untouched', (
      WidgetTester tester,
    ) async {
      const String prose = r'The award is worth $500 each session.';
      await tester.pumpWidget(_wrap(const MathText(prose)));
      await tester.pumpAndSettle();

      expect(find.text(prose), findsOneWidget);
    });

    testWidgets('a formula renders without throwing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const MathText(r'Simplify $\frac{x^2 - 9}{x - 3}$ for $x \neq 3$.')),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // Mixed content becomes a rich Text rather than a plain one.
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('a malformed formula falls back instead of crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const MathText(r'Broken $\frac{\frac$ formula')),
      );
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
        reason: 'a bad formula must never take an exam paper down',
      );
    });

    testWidgets('common Nigerian syllabus notation renders cleanly', (
      WidgetTester tester,
    ) async {
      const List<String> samples = <String>[
        r'Evaluate $\int_0^\infty e^{-st}\,dt$',
        r'Solve $x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$',
        r'Find $\lim_{x \to 0} \frac{\sin x}{x}$',
        r'Given $\log_{10} 1000 = 3$',
        r'The matrix $\begin{bmatrix} a & b \\ c & d \end{bmatrix}$',
      ];

      for (final String sample in samples) {
        await tester.pumpWidget(_wrap(MathText(sample)));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: sample);
      }
    });
  });
}
