import 'package:eduvora/core/models/gpa.dart';
import 'package:flutter_test/flutter_test.dart';

CourseEntry c(String code, int u, Grade g) =>
    CourseEntry(id: code + u.toString(), code: code, creditUnits: u, grade: g);

void main() {
  final SemesterRecord s1 = SemesterRecord(
    id: '1',
    label: 'S1',
    savedAt: DateTime(2026, 1, 1),
    courses: <CourseEntry>[
      c('MTH 101', 3, Grade.a),
      c('PHY 101', 2, Grade.f),
      c('CHM 101', 2, Grade.b),
    ],
  );
  final SemesterRecord s2 = SemesterRecord(
    id: '2',
    label: 'S2',
    savedAt: DateTime(2026, 6, 1),
    courses: <CourseEntry>[c('phy101', 2, Grade.c)],
  );

  test('semester GPA = TCP / TNU with F counted', () {
    expect(s1.totalUnits, 7);
    expect(s1.totalQualityPoints, 23);
    expect(s1.gpa, closeTo(3.2857, 0.0001));
  });

  test('score bands', () {
    expect(Grade.fromScore(70), Grade.a);
    expect(Grade.fromScore(69), Grade.b);
    expect(Grade.fromScore(45), Grade.d);
    expect(Grade.fromScore(40), Grade.e);
    expect(Grade.fromScore(39), Grade.f);
    expect(Grade.fromScore(101), isNull);
  });

  test('carryover listed until the resit is passed', () {
    final CumulativeResult only1 =
        GpaEngine.cumulative(<SemesterRecord>[s1], const GpaSettings());
    expect(only1.carryovers, <String>['PHY 101']);
    final CumulativeResult both =
        GpaEngine.cumulative(<SemesterRecord>[s1, s2], const GpaSettings());
    expect(both.carryovers, isEmpty);
  });

  test('both attempts count by default; F replaced when the school drops it', () {
    final CumulativeResult keep =
        GpaEngine.cumulative(<SemesterRecord>[s1, s2], const GpaSettings());
    expect(keep.units, 9);
    expect(keep.points, 29);
    final CumulativeResult drop = GpaEngine.cumulative(
      <SemesterRecord>[s1, s2],
      const GpaSettings(replaceRetakenFails: true),
    );
    expect(drop.units, 7);
    expect(drop.points, 29);
    expect(drop.cgpa, closeTo(4.1429, 0.0001));
  });

  test('previous CGPA and units carry in; ungraded courses are ignored', () {
    final SemesterRecord withBlank = SemesterRecord(
      id: '3',
      label: 'S3',
      savedAt: DateTime(2026, 9, 1),
      courses: <CourseEntry>[
        c('ENG 101', 2, Grade.a),
        const CourseEntry(id: 'x', code: 'ZZZ 100', creditUnits: 3),
      ],
    );
    final CumulativeResult r = GpaEngine.cumulative(
      <SemesterRecord>[withBlank],
      const GpaSettings(previousCgpa: 3.0, previousUnits: 60),
    );
    expect(r.units, 62);
    expect(r.points, 190);
  });

  test('needed GPA for a target', () {
    final double? need = GpaEngine.neededGpa(
      target: 4.5,
      unitsSoFar: 60,
      pointsSoFar: 240,
      nextUnits: 20,
    );
    expect(need, closeTo(4.5 * 80 / 20 - 12, 0.0001)); // (360-240)/20 = 6.0
  });
}
