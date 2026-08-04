import 'package:eduvora/core/models/gpa.dart';
import 'package:eduvora/core/models/institution.dart';
import 'package:eduvora/core/services/local_store.dart';
import 'package:eduvora/core/state/session_controller.dart';
import 'package:eduvora/features/auth/presentation/screens/auth_screen.dart';
import 'package:eduvora/features/chats/presentation/screens/assistant_screen.dart';
import 'package:eduvora/features/gpa/presentation/screens/gpa_calculator_screen.dart';
import 'package:eduvora/features/home/presentation/screens/home_shell.dart';
import 'package:eduvora/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:eduvora/core/data/nigerian_institutions.dart';
import 'package:eduvora/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.light,
      home: child,
    );

Future<void> _signInTestStudent({bool complete = true}) async {
  await sessionController.signUpWithEmail(
    fullName: 'Chinaza Okeke',
    email: 'chinaza@unilag.edu.ng',
    password: 'passphrase1',
  );
  if (complete) {
    await sessionController.saveProfile(
      sessionController.profile!
          .withInstitution(
            NigerianInstitutions.byName('University of Lagos')!,
          )
          .copyWith(
            faculty: 'Faculty of Science',
            department: 'Microbiology',
            level: '200 Level',
          ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await LocalStore.init();
    await sessionController.signOut();
  });

  group('Sign-in screen', () {
    testWidgets('is what a signed-out student sees, with all the essentials',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const AuthScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Welcome back 👋'), findsOneWidget);
      expect(find.text('Email address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.text('Keep me signed in'), findsOneWidget);
      expect(
        find.text('Discover what Eduvora offers'),
        findsOneWidget,
        reason: 'the landing page must be reachable from sign-in',
      );
    });

    testWidgets('the eye icon reveals and hides the password',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const AuthScreen()));
      await tester.pumpAndSettle();

      EditableText passwordField() => tester.widget<EditableText>(
            find.byType(EditableText).last,
          );

      expect(passwordField().obscureText, isTrue,
          reason: 'password starts hidden');
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      await tester.tap(find.byTooltip('Show password'));
      await tester.pumpAndSettle();

      expect(passwordField().obscureText, isFalse,
          reason: 'tapping the eye reveals the password');
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      await tester.tap(find.byTooltip('Hide password'));
      await tester.pumpAndSettle();

      expect(passwordField().obscureText, isTrue,
          reason: 'tapping again hides it once more');
    });

    testWidgets('switching to Create account reveals the extra fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const AuthScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Full name'), findsNothing);

      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(find.text('Join Eduvora 🎓'), findsOneWidget);
      expect(find.text('Full name'), findsOneWidget);
      expect(find.text('Confirm password'), findsOneWidget);
      expect(find.text('Sign up with Google'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Create my account'),
        findsOneWidget,
      );
    });

    testWidgets('rejects a malformed email and a mismatched password',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const AuthScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Ada');
      await tester.enterText(find.byType(TextFormField).at(1), 'not-an-email');
      await tester.enterText(find.byType(TextFormField).at(2), 'passphrase1');
      await tester.enterText(find.byType(TextFormField).at(3), 'different');
      await tester.pumpAndSettle();

      final Finder submit =
          find.widgetWithText(FilledButton, 'Create my account');
      await tester.ensureVisible(submit);
      await tester.pumpAndSettle();
      await tester.tap(submit);
      await tester.pumpAndSettle();

      expect(
        find.text('That email address does not look quite right.'),
        findsOneWidget,
      );
      expect(find.text('The two passwords do not match.'), findsOneWidget);
    });
  });

  group('Onboarding', () {
    testWidgets('walks from institution type through to level',
        (WidgetTester tester) async {
      await _signInTestStudent(complete: false);
      await tester.pumpWidget(_wrap(const OnboardingScreen(editing: true)));
      await tester.pumpAndSettle();

      // Step 1 — institution type.
      expect(
        find.text('What kind of institution do you attend?'),
        findsOneWidget,
      );
      expect(find.text('Universities'), findsOneWidget);
      expect(find.text('Polytechnics'), findsOneWidget);
      expect(find.text('Colleges of Education'), findsOneWidget);

      final Finder continueButton =
          find.widgetWithText(FilledButton, 'Continue');
      expect(
        tester.widget<FilledButton>(continueButton).onPressed,
        isNull,
        reason: 'cannot advance before choosing',
      );

      await tester.tap(find.text('Universities'));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(continueButton).onPressed, isNotNull);

      // Step 2 — find the institution.
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      expect(find.text('Find your institution'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'unilag');
      await tester.pumpAndSettle();
      expect(find.text('University of Lagos'), findsOneWidget);

      await tester.tap(find.text('University of Lagos'));
      await tester.pumpAndSettle();

      // Step 3 — faculty.
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      expect(find.text('Choose your faculty'), findsOneWidget);
      expect(find.text('Faculty of Science'), findsOneWidget);

      await tester.tap(find.text('Faculty of Science'));
      await tester.pumpAndSettle();

      // Step 4 — department.
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      expect(find.text('Choose your department'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'micro');
      await tester.pumpAndSettle();
      expect(find.text('Microbiology'), findsOneWidget);
      await tester.tap(find.text('Microbiology'));
      await tester.pumpAndSettle();

      // Step 5 — level.
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      expect(find.text('What level are you in?'), findsOneWidget);
      expect(find.text('300 Level'), findsOneWidget);

      await tester.tap(find.text('300 Level'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(FilledButton, 'Enter Eduvora'), findsOneWidget);
    });

    testWidgets('polytechnic students get ND and HND levels',
        (WidgetTester tester) async {
      await _signInTestStudent(complete: false);
      await tester.pumpWidget(_wrap(const OnboardingScreen(editing: true)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Polytechnics'));
      await tester.pumpAndSettle();

      final Finder continueButton =
          find.widgetWithText(FilledButton, 'Continue');
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'yabatech');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yaba College of Technology'));
      await tester.pumpAndSettle();

      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      expect(
        find.text('School of Engineering Technology'),
        findsOneWidget,
        reason: 'polytechnics use schools, not faculties',
      );
    });
  });

  group('Dashboard shell', () {
    testWidgets('greets the student and shows every feature tile',
        (WidgetTester tester) async {
      await _signInTestStudent();
      await tester.pumpWidget(_wrap(const HomeShell()));
      await tester.pumpAndSettle();

      expect(find.textContaining('Chinaza'), findsWidgets);
      expect(find.text('Everything you need'), findsOneWidget);

      for (final String tile in <String>[
        'Academic\nvideos',
        'CBT exam\npractice',
        'GP\ncalculator',
        'Materials\n& notes',
        'Upload a\nresource',
        'Student\ncommunity',
        'Scholarship\nnews',
        'Ask\nAda',
      ]) {
        expect(find.text(tile), findsOneWidget, reason: 'missing tile: $tile');
      }

      // The five-tab bottom bar.
      for (final String tab in <String>[
        'Home',
        'Materials',
        'Community',
        'Chats',
        'Profile',
      ]) {
        expect(find.text(tab), findsWidgets, reason: 'missing tab: $tab');
      }
    });

    testWidgets('the profile tab shows the chosen academic identity',
        (WidgetTester tester) async {
      await _signInTestStudent();
      await tester.pumpWidget(_wrap(const HomeShell()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile').last);
      await tester.pumpAndSettle();

      expect(find.text('University of Lagos'), findsOneWidget);
      expect(find.text('Microbiology'), findsOneWidget);
      expect(find.text('200 Level'), findsOneWidget);

      // The account section sits further down the page.
      await tester.scrollUntilVisible(
        find.text('Campus Mode'),
        320,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      expect(find.text('Campus Mode'), findsOneWidget);
      expect(find.text('Sign out'), findsOneWidget);
    });
  });

  group('GP calculator', () {
    testWidgets('computes a semester GPA from entered courses',
        (WidgetTester tester) async {
      await _signInTestStudent();
      await tester.pumpWidget(_wrap(const GpaCalculatorScreen()));
      await tester.pumpAndSettle();

      // The default row is 3 units at grade A, so 15/3 = 5.00.
      expect(find.text('5.00'), findsWidgets);
      expect(find.text('First Class'), findsWidgets);

      // Drop the grade to a C: 3 units × 3 points = 9/3 = 3.00.
      final Finder gradePicker =
          find.byType(DropdownButtonFormField<Grade>).first;
      await tester.ensureVisible(gradePicker);
      await tester.pumpAndSettle();
      await tester.tap(gradePicker, warnIfMissed: false);
      await tester.pumpAndSettle();

      await tester.tap(find.text('C (3)').last);
      await tester.pumpAndSettle();

      expect(find.text('3.00'), findsWidgets);
      expect(find.text('Second Class Lower'), findsWidgets);
    });

    testWidgets('explains the grading scale on request',
        (WidgetTester tester) async {
      await _signInTestStudent();
      await tester.pumpWidget(_wrap(const GpaCalculatorScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Grading scale'));
      await tester.pumpAndSettle();

      expect(find.text('The 5-point scale'), findsOneWidget);
      expect(
        find.text('GPA = Σ (credit units × grade value) ⁄ Σ credit units'),
        findsOneWidget,
      );
      expect(find.text('Excellent'), findsOneWidget);
      expect(find.text('Fail'), findsOneWidget);
    });
  });

  group('Ada, the assistant', () {
    testWidgets('greets warmly and answers a navigation question',
        (WidgetTester tester) async {
      await _signInTestStudent();
      await tester.pumpWidget(_wrap(const AssistantScreen()));
      await tester.pumpAndSettle();

      expect(find.textContaining('I am Ada'), findsOneWidget);

      // The starter prompts sit in a horizontal strip above the composer.
      final Finder prompt = find.text('How does the GP calculator work?');
      expect(prompt, findsOneWidget);
      await tester.ensureVisible(prompt);
      await tester.pumpAndSettle();

      await tester.tap(prompt);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      expect(find.textContaining('5-point scale'), findsWidgets);
      expect(find.text('Open the GP calculator'), findsOneWidget);
    });

    testWidgets('responds kindly when a student says they are struggling',
        (WidgetTester tester) async {
      await _signInTestStudent();
      await tester.pumpWidget(_wrap(const AssistantScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).first,
        'I am completely overwhelmed',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      expect(find.textContaining('Thank you for telling me'), findsOneWidget);
      expect(find.text('Open the Wellbeing channel'), findsOneWidget);
    });
  });

  group('Session', () {
    test('sign up then sign in restores the saved academic identity',
        () async {
      await _signInTestStudent();
      expect(sessionController.status, AuthStatus.ready);
      expect(sessionController.profile!.department, 'Microbiology');

      await sessionController.signOut();
      expect(sessionController.status, AuthStatus.signedOut);
      expect(sessionController.profile, isNull);

      await sessionController.signInWithEmail(
        email: 'chinaza@unilag.edu.ng',
        password: 'passphrase1',
      );

      expect(sessionController.status, AuthStatus.ready);
      expect(sessionController.profile!.department, 'Microbiology');
      expect(
        sessionController.profile!.institutionType,
        InstitutionType.university,
      );
    });

    test('the wrong password is refused with a readable message', () async {
      await _signInTestStudent();
      await sessionController.signOut();

      expect(
        () => sessionController.signInWithEmail(
          email: 'chinaza@unilag.edu.ng',
          password: 'wrong-one',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (AuthFailure f) => f.message,
            'message',
            contains('does not match'),
          ),
        ),
      );
    });

    test('an unknown email is refused politely', () async {
      expect(
        () => sessionController.signInWithEmail(
          email: 'nobody@example.ng',
          password: 'whatever',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (AuthFailure f) => f.message,
            'message',
            contains('could not find an account'),
          ),
        ),
      );
    });

    test('signing up twice with the same email is refused', () async {
      await _signInTestStudent(complete: false);
      await sessionController.signOut();

      expect(
        () => sessionController.signUpWithEmail(
          fullName: 'Someone Else',
          email: 'chinaza@unilag.edu.ng',
          password: 'another1',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (AuthFailure f) => f.message,
            'message',
            contains('already exists'),
          ),
        ),
      );
    });
  });
}
