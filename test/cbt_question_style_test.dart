// Guards the CBT question/option typography against silently drifting back
// to the heavy, oversized styling that made exam text read as bold and
// cramped on a phone. Asserts against the real widget tree, not the source.
import 'package:eduvora/core/widgets/math_text.dart';
import 'package:eduvora/features/cbt/presentation/screens/cbt_exam_screen.dart';
import 'package:eduvora/core/models/cbt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const CbtSubject subject = CbtSubject(
    id: 'style-probe',
    name: 'Style Probe',
    description: 'A probe paper used only to assert exam typography.',
    questions: <CbtQuestion>[
      CbtQuestion(
        id: 'style-probe-q1',
        question: 'Evaluate the limit of the sample expression.',
        options: <String>['first', 'second', 'third', 'fourth'],
        correctIndex: 0,
        explanation: 'Sample explanation.',
        topic: 'Sample topic',
      ),
    ],
  );

  testWidgets('the question stem is neither bold nor oversized', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CbtExamScreen(
          subject: subject,
          config: CbtExamConfig.standard(subject),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final MathText stem = tester.widget<MathText>(
      find
          .byWidgetPredicate(
            (Widget w) =>
                w is MathText &&
                w.text == 'Evaluate the limit of the sample expression.',
          )
          .first,
    );

    // Regular weight: a semi-bold (w600+) stem is what the heavy look was.
    expect(stem.style?.fontWeight, FontWeight.w400);
    // And comfortably sized for a phone rather than headline-scale.
    expect(stem.style?.fontSize, lessThanOrEqualTo(17.0));
  });

  testWidgets('an unselected option is regular weight and not oversized', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CbtExamScreen(
          subject: subject,
          config: CbtExamConfig.standard(subject),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final MathText option = tester.widget<MathText>(
      find
          .byWidgetPredicate((Widget w) => w is MathText && w.text == 'first')
          .first,
    );

    expect(option.style?.fontWeight, FontWeight.w400);
    expect(option.style?.fontSize, lessThanOrEqualTo(16.0));
  });
}
