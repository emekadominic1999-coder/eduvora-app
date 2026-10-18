import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Opens the small exam calculator as a bottom sheet.
Future<void> showExamCalculator(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColours.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _ExamCalculator(),
  );
}

/// Evaluates `+ - × ÷ ^`, brackets, `√`, `%` and `π` without any package.
class CalcParser {
  CalcParser(String source)
    : _s = source
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-')
          .replaceAll(' ', '');

  final String _s;
  int _i = 0;

  double evaluate() {
    final double v = _expr();
    if (_i != _s.length) throw const FormatException('unexpected input');
    return v;
  }

  bool _eat(String c) {
    if (_i < _s.length && _s[_i] == c) {
      _i++;
      return true;
    }
    return false;
  }

  double _expr() {
    double v = _term();
    while (true) {
      if (_eat('+')) {
        v += _term();
      } else if (_eat('-')) {
        v -= _term();
      } else {
        return v;
      }
    }
  }

  double _term() {
    double v = _power();
    while (true) {
      if (_eat('*')) {
        v *= _power();
      } else if (_eat('/')) {
        v /= _power();
      } else if (_i < _s.length &&
          (_s[_i] == '(' || _s[_i] == '√' || _s[_i] == 'π')) {
        v *= _power();
      } else {
        return v;
      }
    }
  }

  double _power() {
    final double base = _unary();
    if (_eat('^')) return math.pow(base, _power()).toDouble();
    return base;
  }

  double _unary() {
    if (_eat('-')) return -_unary();
    if (_eat('+')) return _unary();
    if (_eat('√')) {
      final double v = _unary();
      if (v < 0) throw const FormatException('negative root');
      return math.sqrt(v);
    }
    return _postfix();
  }

  double _postfix() {
    double v = _atom();
    while (_eat('%')) {
      v /= 100;
    }
    return v;
  }

  double _atom() {
    if (_eat('(')) {
      final double v = _expr();
      _eat(')');
      return v;
    }
    if (_eat('π')) return math.pi;
    final int start = _i;
    while (_i < _s.length && (RegExp(r'[0-9.]').hasMatch(_s[_i]))) {
      _i++;
    }
    if (start == _i) throw const FormatException('number expected');
    return double.parse(_s.substring(start, _i));
  }
}

String formatCalc(double v) {
  if (v.isNaN || v.isInfinite) return 'Error';
  if (v == v.roundToDouble() && v.abs() < 1e12) return v.toInt().toString();
  String s = v.toStringAsPrecision(10);
  if (s.contains('e')) return s;
  if (s.contains('.')) {
    s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }
  return s;
}

class _ExamCalculator extends StatefulWidget {
  const _ExamCalculator();

  @override
  State<_ExamCalculator> createState() => _ExamCalculatorState();
}

class _ExamCalculatorState extends State<_ExamCalculator> {
  String _expr = '';
  String _result = '';

  void _press(String k) {
    setState(() {
      switch (k) {
        case 'C':
          _expr = '';
          _result = '';
        case '⌫':
          if (_expr.isNotEmpty) _expr = _expr.substring(0, _expr.length - 1);
          _result = '';
        case '=':
          if (_expr.isEmpty) return;
          try {
            _result = formatCalc(CalcParser(_expr).evaluate());
          } catch (_) {
            _result = 'Error';
          }
        default:
          if (_result.isNotEmpty && _result != 'Error') {
            // A digit starts a new sum; an operator carries on from the answer.
            _expr = RegExp(r'^[0-9.(√π]$').hasMatch(k) ? '' : _result;
          }
          _result = '';
          _expr += k == 'x²' ? '^2' : k;
      }
    });
  }

  Widget _key(String k, {Color? bg, Color? fg}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Material(
          color: bg ?? AppColours.primaryTint,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _press(k),
            child: SizedBox(
              height: 46,
              child: Center(
                child: Text(
                  k,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: fg ?? AppColours.text,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(List<String> keys) => Row(
    children: <Widget>[
      for (final String k in keys)
        _key(
          k,
          bg: k == '='
              ? AppColours.primary
              : (RegExp(r'^[0-9.]$').hasMatch(k) ? AppColours.surface : null),
          fg: k == '=' ? Colors.white : null,
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColours.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColours.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _expr.isEmpty ? '0' : _expr,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColours.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _result.isEmpty ? ' ' : _result,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _row(const <String>['C', '(', ')', '⌫']),
            _row(const <String>['√', 'x²', '^', '÷']),
            _row(const <String>['7', '8', '9', '×']),
            _row(const <String>['4', '5', '6', '−']),
            _row(const <String>['1', '2', '3', '+']),
            _row(const <String>['0', '.', 'π', '=']),
          ],
        ),
      ),
    );
  }
}
