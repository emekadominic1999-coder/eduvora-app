import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// A password input with a show/hide eye control.
///
/// The eye is always present: tapping it reveals the characters so a student
/// can confirm what they have typed, and tapping again hides them. The icon
/// itself changes between an open and a struck-through eye so the current
/// state is obvious at a glance.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.showStrength = false,
    this.autofillHint = AutofillHints.password,
  });

  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  /// Shows a live strength meter, used when creating an account.
  final bool showStrength;
  final String autofillHint;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    if (widget.showStrength) {
      widget.controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    if (widget.showStrength) {
      widget.controller.removeListener(_onChanged);
    }
    super.dispose();
  }

  void _onChanged() => setState(() {});

  void _toggle() => setState(() => _obscured = !_obscured);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          controller: widget.controller,
          obscureText: _obscured,
          obscuringCharacter: '•',
          enableSuggestions: false,
          autocorrect: false,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          autofillHints: <String>[widget.autofillHint],
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
            suffixIcon: Semantics(
              button: true,
              label: _obscured ? 'Show password' : 'Hide password',
              child: IconButton(
                onPressed: _toggle,
                splashRadius: 21,
                tooltip: _obscured ? 'Show password' : 'Hide password',
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: Icon(
                    _obscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    key: ValueKey<bool>(_obscured),
                    size: 21,
                    color: _obscured
                        ? AppColours.textFaint
                        : AppColours.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.showStrength && widget.controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: _StrengthMeter(password: widget.controller.text),
          ),
      ],
    );
  }
}

class _StrengthMeter extends StatelessWidget {
  const _StrengthMeter({required this.password});

  final String password;

  /// 0 = weak, 1 = fair, 2 = good, 3 = strong.
  int get _score {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    final bool hasLetters = RegExp(r'[A-Za-z]').hasMatch(password);
    final bool hasDigits = RegExp(r'\d').hasMatch(password);
    final bool hasSymbols = RegExp(r'[^A-Za-z0-9]').hasMatch(password);
    if (hasLetters && hasDigits) score++;
    if (hasSymbols) score++;
    return score.clamp(0, 3);
  }

  static const List<String> _labels = <String>[
    'Weak', 'Fair', 'Good', 'Strong',
  ];

  static const List<Color> _colours = <Color>[
    AppColours.danger,
    AppColours.warning,
    AppColours.info,
    AppColours.success,
  ];

  @override
  Widget build(BuildContext context) {
    final int score = _score;
    return Row(
      children: <Widget>[
        ...List<Widget>.generate(4, (int i) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: i == 3 ? 0 : 4),
              decoration: BoxDecoration(
                color: i <= score ? _colours[score] : AppColours.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
        const SizedBox(width: AppSpacing.md),
        SizedBox(
          width: 46,
          child: Text(
            _labels[score],
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: _colours[score],
            ),
          ),
        ),
      ],
    );
  }
}
