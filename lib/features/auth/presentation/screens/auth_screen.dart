import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/eduvora_logo.dart';
import '../../../home/presentation/screens/home_shell.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';
import '../widgets/google_button.dart';
import '../widgets/password_field.dart';

/// Sign in and create account.
///
/// This is the first screen a student meets. The composition follows the
/// centred-card pattern requested for Eduvora: brand mark, a warm welcome, the
/// form, a Google option, and a quiet route into the landing page for anyone
/// who wants to read about the app before signing up.
///
/// There is deliberately **no footer here** — the footer belongs to the
/// landing page alone.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum _Mode { signIn, signUp }

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  _Mode _mode = _Mode.signIn;
  bool _remember = true;
  bool _agree = false;
  bool _submitting = false;
  String? _error;

  bool get _isSignIn => _mode == _Mode.signIn;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _switchMode(_Mode mode) {
    if (_mode == mode) return;
    setState(() {
      _mode = mode;
      _error = null;
    });
    _formKey.currentState?.reset();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_isSignIn && !_agree) {
      setState(
        () => _error =
            'Please accept the community guidelines to create your account.',
      );
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      if (_isSignIn) {
        await sessionController.signInWithEmail(
          email: _email.text,
          password: _password.text,
        );
      } else {
        await sessionController.signUpWithEmail(
          fullName: _name.text,
          email: _email.text,
          password: _password.text,
        );
      }
      if (!mounted) return;
      _routeOnwards();
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = SessionController.describeError(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _google() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await sessionController.signInWithGoogle();
      if (!mounted) return;
      if (sessionController.isSignedIn) {
        _routeOnwards();
      } else {
        showEduvoraSnack(
          context,
          'Complete the sign-in in your browser, then return to Eduvora.',
          icon: Icons.open_in_new_rounded,
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = SessionController.describeError(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _routeOnwards() {
    final bool complete = sessionController.profile?.isComplete ?? false;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => complete ? const HomeShell() : const OnboardingScreen(),
      ),
      (Route<dynamic> _) => false,
    );
  }

  Future<void> _forgotPassword() async {
    try {
      await sessionController.sendPasswordReset(_email.text);
      if (!mounted) return;
      showEduvoraSnack(
        context,
        'A reset link is on its way to ${_email.text.trim()}.',
        icon: Icons.mark_email_read_rounded,
      );
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(
        context,
        SessionController.describeError(error),
        isError: true,
      );
    }
  }

  // ---------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.lightOverlay,
      child: Scaffold(
        backgroundColor: AppColours.background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.lg,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - AppSpacing.xxl,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: AppSpacing.sm),
                          _header(text),
                          const SizedBox(height: AppSpacing.xl),
                          _card(text),
                          const SizedBox(height: AppSpacing.xl),
                          _discoverLink(text),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _header(TextTheme text) {
    return Column(
      children: <Widget>[
        const Center(child: EduvoraLogo(size: 62)),
        const SizedBox(height: AppSpacing.lg),
        Text(
          _isSignIn ? 'Welcome back 👋' : 'Join Eduvora 🎓',
          textAlign: TextAlign.center,
          style: text.displaySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _isSignIn
              ? 'Sign in to pick up exactly where you left off.'
              : 'Create your account and meet your coursemates.',
          textAlign: TextAlign.center,
          style: text.bodyMedium?.copyWith(color: AppColours.textMuted),
        ),
      ],
    );
  }

  Widget _card(TextTheme text) {
    return EduvoraCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      shadows: AppShadows.raised,
      child: Form(
        key: _formKey,
        // Once a field has been touched, re-validate it live as the student
        // types rather than leaving a stale error (e.g. "passwords do not
        // match") sitting there after they've already fixed it.
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _modeSwitch(),
            const SizedBox(height: AppSpacing.xl),
            if (!_isSignIn) ...<Widget>[
              _label('Full name'),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const <String>[AutofillHints.name],
                decoration: const InputDecoration(
                  hintText: 'e.g. Chinaza Okeke',
                  prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                ),
                validator: (String? value) {
                  final String v = (value ?? '').trim();
                  if (v.isEmpty) return 'Please tell us your name.';
                  if (v.length < 2) return 'That name looks a little short.';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            _label('Email address'),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const <String>[AutofillHints.email],
              decoration: const InputDecoration(
                hintText: 'you@university.edu.ng',
                prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
              ),
              validator: (String? value) {
                final String v = (value ?? '').trim();
                if (v.isEmpty) return 'Please enter your email address.';
                final bool ok = RegExp(
                  r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
                ).hasMatch(v);
                if (!ok) return 'That email address does not look quite right.';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            _label('Password'),
            // The password and confirm fields are wrapped in their own
            // AutofillGroup, and use the "new password" hint rather than
            // "password" (which means *current* password). Two sibling
            // fields both hinted as the current password confuses some
            // browsers' password managers into intercepting keystrokes meant
            // for the second field.
            AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  PasswordField(
                    controller: _password,
                    hint: _isSignIn
                        ? 'Enter your password'
                        : 'At least 6 characters',
                    textInputAction: _isSignIn
                        ? TextInputAction.done
                        : TextInputAction.next,
                    onSubmitted: _isSignIn ? (_) => _submit() : null,
                    showStrength: !_isSignIn,
                    autofillHint: _isSignIn
                        ? AutofillHints.password
                        : AutofillHints.newPassword,
                    validator: (String? value) {
                      final String v = value ?? '';
                      if (v.isEmpty) return 'Please enter your password.';
                      if (!_isSignIn && v.length < 6) {
                        return 'Use at least six characters to keep your account safe.';
                      }
                      return null;
                    },
                  ),
                  if (!_isSignIn) ...<Widget>[
                    const SizedBox(height: AppSpacing.lg),
                    _label('Confirm password'),
                    PasswordField(
                      controller: _confirm,
                      hint: 'Type it once more',
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      autofillHint: AutofillHints.newPassword,
                      validator: (String? value) {
                        if ((value ?? '') != _password.text) {
                          return 'The two passwords do not match.';
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_isSignIn) _rememberRow(text) else _agreeRow(text),
            if (_error != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              _errorBanner(_error!),
            ],
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(_isSignIn ? 'Sign in' : 'Create my account'),
            ),
            const SizedBox(height: AppSpacing.xl),
            _divider(text),
            const SizedBox(height: AppSpacing.lg),
            GoogleButton(
              label: _isSignIn ? 'Sign in with Google' : 'Sign up with Google',
              onPressed: _submitting ? null : _google,
            ),
            const SizedBox(height: AppSpacing.xl),
            _switchPrompt(text),
          ],
        ),
      ),
    );
  }

  Widget _modeSwitch() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: AppColours.surfaceMuted,
        borderRadius: AppRadii.md,
      ),
      child: Row(
        children: <Widget>[
          Expanded(child: _modeTab('Sign in', _Mode.signIn)),
          Expanded(child: _modeTab('Create account', _Mode.signUp)),
        ],
      ),
    );
  }

  Widget _modeTab(String label, _Mode mode) {
    final bool active = _mode == mode;
    return GestureDetector(
      onTap: () => _switchMode(mode),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColours.surface : Colors.transparent,
          borderRadius: AppRadii.sm,
          boxShadow: active ? AppShadows.subtle : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? AppColours.primary : AppColours.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _label(String value) => Padding(
    padding: const EdgeInsets.only(bottom: 7, left: 2),
    child: Text(
      value,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColours.text,
      ),
    ),
  );

  Widget _rememberRow(TextTheme text) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: _remember,
            onChanged: (bool? v) => setState(() => _remember = v ?? true),
            activeColor: AppColours.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(color: AppColours.borderStrong, width: 1.5),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'Keep me signed in',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        TextButton(
          onPressed: _submitting ? null : _forgotPassword,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Forgot password?'),
        ),
      ],
    );
  }

  Widget _agreeRow(TextTheme text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: _agree,
            onChanged: (bool? v) => setState(() => _agree = v ?? false),
            activeColor: AppColours.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(color: AppColours.borderStrong, width: 1.5),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'I agree to the Eduvora community guidelines and to keeping this '
              'a respectful space for fellow students.',
              style: text.bodySmall,
            ),
          ),
        ),
      ],
    );
  }

  Widget _errorBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColours.dangerSoft,
        borderRadius: AppRadii.sm,
        border: Border.all(color: AppColours.danger.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColours.danger,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Color(0xFF991B1B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(TextTheme text) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider(color: AppColours.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'or continue with',
            style: text.bodySmall?.copyWith(fontSize: 12),
          ),
        ),
        const Expanded(child: Divider(color: AppColours.border)),
      ],
    );
  }

  Widget _switchPrompt(TextTheme text) {
    // A Wrap rather than a Row so the prompt flows onto a second line on
    // narrow handsets and at large system font scales.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(
          _isSignIn ? 'New to Eduvora?' : 'Already have an account?',
          style: text.bodySmall,
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () => _switchMode(_isSignIn ? _Mode.signUp : _Mode.signIn),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(_isSignIn ? 'Create an account' : 'Sign in instead'),
        ),
      ],
    );
  }

  Widget _discoverLink(TextTheme text) {
    return Center(
      child: TextButton.icon(
        onPressed: () => Navigator.of(context).pushNamed(AppRouter.landing),
        icon: const Icon(Icons.explore_outlined, size: 18),
        style: TextButton.styleFrom(foregroundColor: AppColours.textMuted),
        label: const Text('Discover what Eduvora offers'),
      ),
    );
  }
}
