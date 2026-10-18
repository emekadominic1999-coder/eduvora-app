import 'package:flutter_test/flutter_test.dart';
import 'package:eduvora/features/cbt/presentation/widgets/exam_calculator.dart';

void main() {
  test('calculator parser', () {
    double e(String s) => CalcParser(s).evaluate();
    expect(e('2+3×4'), 14);
    expect(e('(2+3)×4'), 20);
    expect(e('√16+2^3'), 12);
    expect(e('50%×200'), 100);
    expect(e('10÷4'), 2.5);
    expect(formatCalc(0.1 + 0.2), '0.3');
  });
}
