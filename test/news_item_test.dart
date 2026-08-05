import 'package:eduvora/core/models/news_item.dart';
import 'package:flutter_test/flutter_test.dart';

NewsItem item({
  String link = '',
  NewsCategory category = NewsCategory.academic,
  DateTime? deadline,
}) => NewsItem(
  id: 'n1',
  title: 'Chevening Scholarship 2027 now open',
  summary: 'Applications are open to Nigerian graduates.',
  category: category,
  source: 'Scholarship Region',
  publishedAt: DateTime(2026, 8, 5),
  link: link,
  deadline: deadline,
);

void main() {
  group('external links', () {
    test('an https link is offered to the student', () {
      expect(item(link: 'https://example.com/story').hasExternalLink, isTrue);
    });

    test('an http link is offered too', () {
      expect(item(link: 'http://example.com/story').hasExternalLink, isTrue);
    });

    test('an empty link is not', () {
      expect(item().hasExternalLink, isFalse);
    });

    test('the internal placeholder is not', () {
      // Entries added by hand carry this instead of a URL, because the news
      // table keys on `link`. Tapping it would go nowhere.
      expect(
        item(link: 'eduvora:manual/abc-123').hasExternalLink,
        isFalse,
      );
    });

    test('a bare domain without a scheme is not', () {
      expect(item(link: 'example.com/story').hasExternalLink, isFalse);
    });
  });

  group('action label', () {
    test('reads Apply for a scholarship', () {
      expect(item(category: NewsCategory.scholarship).actionLabel, 'Apply');
    });

    test('reads Apply for an internship or job', () {
      expect(item(category: NewsCategory.opportunity).actionLabel, 'Apply');
    });

    test('reads Apply for a competition', () {
      expect(item(category: NewsCategory.competition).actionLabel, 'Apply');
    });

    test('reads Read full story for an academic notice', () {
      // "Apply" on a report about an ASUU meeting makes no sense.
      expect(
        item(category: NewsCategory.academic).actionLabel,
        'Read full story',
      );
    });

    test('reads Read full story for an admissions notice', () {
      expect(
        item(category: NewsCategory.admission).actionLabel,
        'Read full story',
      );
    });

    test('every category has a label', () {
      for (final NewsCategory c in NewsCategory.values) {
        expect(item(category: c).actionLabel, isNotEmpty, reason: c.name);
      }
    });
  });

  group('categories from the feed', () {
    test('map from the names the ingest function writes', () {
      // These strings are what the Edge Function stores; a mismatch would
      // quietly file everything as "academic".
      expect(NewsCategory.fromName('scholarship'), NewsCategory.scholarship);
      expect(NewsCategory.fromName('admission'), NewsCategory.admission);
      expect(NewsCategory.fromName('academic'), NewsCategory.academic);
      expect(NewsCategory.fromName('opportunity'), NewsCategory.opportunity);
      expect(NewsCategory.fromName('competition'), NewsCategory.competition);
    });

    test('an unknown category falls back rather than throwing', () {
      expect(NewsCategory.fromName('nonsense'), NewsCategory.academic);
      expect(NewsCategory.fromName(null), NewsCategory.academic);
    });
  });

  group('deadlines', () {
    test('a story without one says so', () {
      expect(item().hasDeadline, isFalse);
      expect(item().deadlineLabel, 'Rolling application');
    });

    test('a past deadline reads as closed', () {
      expect(
        item(deadline: DateTime.now().subtract(const Duration(days: 3)))
            .deadlineLabel,
        'Closed',
      );
    });

    test('a deadline days away counts down', () {
      expect(
        item(deadline: DateTime.now().add(const Duration(days: 9, hours: 1)))
            .deadlineLabel,
        'Closes in 9 days',
      );
    });
  });

  group('JSON from Supabase', () {
    test('a row written by the feed decodes fully', () {
      final NewsItem decoded = NewsItem.fromJson(<String, dynamic>{
        'id': 'abc',
        'title': 'UK Government Chevening Scholarship 2027 | Fully Funded',
        'summary': 'Applications are open.',
        'category': 'scholarship',
        'source': 'Scholarship Region',
        'link': 'https://scholarshipregion.com/chevening-2027/',
        'published_at': '2026-08-04T09:00:00.000Z',
      });

      expect(decoded.category, NewsCategory.scholarship);
      expect(decoded.source, 'Scholarship Region');
      expect(decoded.hasExternalLink, isTrue);
      expect(decoded.actionLabel, 'Apply');
      expect(decoded.title, contains('|'));
    });

    test('a row missing optional fields still decodes', () {
      final NewsItem decoded = NewsItem.fromJson(<String, dynamic>{
        'id': 'abc',
        'title': 'Something happened',
      });
      expect(decoded.summary, isEmpty);
      expect(decoded.hasExternalLink, isFalse);
      expect(decoded.category, NewsCategory.academic);
    });
  });
}
