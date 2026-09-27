import 'package:eduvora/core/models/student_profile.dart';
import 'package:eduvora/core/services/eduvora_ai.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const StudentProfile profile = StudentProfile(
    id: '1',
    fullName: 'Chinaza Okafor',
    email: 'chinaza@example.com',
    institutionName: 'University of Nigeria, Nsukka',
    faculty: 'Faculty of Engineering',
    department: 'Mechanical Engineering',
    level: '200 Level',
  );

  test('explains unlocking a CBT paper and points at CBT', () {
    final AiReply reply = EduvoraAi.respond(
      'why is this paper locked, how much is cbt',
      profile,
    );
    expect(reply.route, '/cbt');
    expect(reply.message, contains('350'));
    expect(reply.message, contains('2,300'));
  });

  test('explains referrals and points at the referral screen', () {
    final AiReply reply = EduvoraAi.respond(
      'how does the referral code work',
      profile,
    );
    expect(reply.route, '/referral');
    expect(reply.message, contains('10%'));
    expect(reply.message, contains('1,000'));
  });

  test('explains tutors', () {
    final AiReply reply = EduvoraAi.respond('how do I find a tutor', profile);
    expect(reply.message.toLowerCase(), contains('tutor'));
  });

  test('GP calculator answer mentions the score box and resits', () {
    final AiReply reply = EduvoraAi.respond(
      'how does the gp calculator work',
      profile,
    );
    expect(reply.route, '/gpa');
    expect(reply.message.toLowerCase(), contains('score'));
    expect(reply.message.toLowerCase(), contains('resit'));
  });

  test('carry-over emotional support still wins over the classification intent', () {
    final AiReply reply = EduvoraAi.respond(
      'I have a carry over in thermodynamics',
      profile,
    );
    expect(reply.route, '/gpa');
    expect(reply.message, contains('yet'));
  });
}
