import 'package:eduvora/core/data/nigerian_institutions.dart';
import 'package:eduvora/core/models/institution.dart';
import 'package:eduvora/core/widgets/institution_crest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('crest colours', () {
    test('are stable for the same institution', () {
      expect(
        InstitutionCrest.colourFor('University of Nigeria, Nsukka'),
        InstitutionCrest.colourFor('University of Nigeria, Nsukka'),
      );
    });

    test('ignore casing and stray whitespace', () {
      expect(
        InstitutionCrest.colourFor('  University of Lagos '),
        InstitutionCrest.colourFor('university of lagos'),
      );
    });

    test('differ between institutions', () {
      expect(
        InstitutionCrest.colourFor('University of Nigeria, Nsukka'),
        isNot(InstitutionCrest.colourFor('University of Lagos')),
      );
    });

    test('spread widely across the real directory', () {
      final List<Institution> all = NigerianInstitutions.all;
      final Set<int> colours = all
          .map((Institution i) => InstitutionCrest.colourFor(i.name).toARGB32())
          .toSet();

      // Some collisions are inevitable in a fixed hue space, but the palette
      // must not collapse — neighbouring schools in a list should look apart.
      expect(colours.length, greaterThan(all.length ~/ 2));
    });

    test('are dark enough for white lettering to read', () {
      for (final Institution i in NigerianInstitutions.all.take(60)) {
        final Color c = InstitutionCrest.colourFor(i.name);
        expect(
          c.computeLuminance(),
          lessThan(0.45),
          reason: '${i.name} is too pale for white text',
        );
      }
    });
  });

  group('crest lettering', () {
    test('uses the abbreviation when there is one', () {
      expect(InstitutionCrest.labelFor('UNN', 'University of Nigeria'), 'UNN');
    });

    test('upper-cases a lower-case abbreviation', () {
      expect(InstitutionCrest.labelFor('futa', 'Federal University'), 'FUTA');
    });

    test('trims an over-long abbreviation rather than overflowing', () {
      expect(
        InstitutionCrest.labelFor('ABCDEFGHIJ', 'Somewhere').length,
        lessThanOrEqualTo(5),
      );
    });

    test('falls back to initials when no abbreviation exists', () {
      expect(
        InstitutionCrest.labelFor('', 'University of Nigeria, Nsukka'),
        'UNN',
      );
    });

    test('never returns empty, even for a nameless entry', () {
      expect(InstitutionCrest.labelFor('', ''), isNotEmpty);
    });

    test('produces a drawable label for every institution shipped', () {
      for (final Institution i in NigerianInstitutions.all) {
        final String label = InstitutionCrest.labelFor(i.abbreviation, i.name);
        expect(label, isNotEmpty, reason: i.name);
        expect(label.length, lessThanOrEqualTo(5), reason: i.name);
      }
    });
  });

  group('crest widget', () {
    testWidgets('renders without a network call', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: InstitutionCrest(
                abbreviation: 'UNN',
                name: 'University of Nigeria, Nsukka',
              ),
            ),
          ),
        ),
      );
      expect(find.byType(InstitutionCrest), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('draws a full directory page without overflowing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: NigerianInstitutions.all
                  .take(40)
                  .map(
                    (Institution i) => SizedBox(
                      height: 60,
                      child: InstitutionCrest.of(i, size: 40),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('builds from a directory entry', (WidgetTester tester) async {
      final Institution first = NigerianInstitutions.all.first;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Center(child: InstitutionCrest.of(first))),
        ),
      );
      expect(find.byType(InstitutionCrest), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
