import 'package:eduvora/core/models/community.dart';
import 'package:eduvora/core/models/news_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('NewsItem carries a picture through a JSON round trip', () {
    final NewsItem item = NewsItem(
      id: '1',
      title: 'Essay competition',
      summary: 'Prizes up to N100,000',
      category: NewsCategory.competition,
      source: 'Eduvora',
      publishedAt: DateTime(2026, 9, 27),
      imageUrl: 'https://example.com/flyer.png',
    );
    expect(item.hasImage, isTrue);

    final NewsItem restored = NewsItem.fromJson(item.toJson());
    expect(restored.imageUrl, 'https://example.com/flyer.png');
    expect(restored.hasImage, isTrue);
  });

  test('a NewsItem with no picture reports hasImage false', () {
    final NewsItem item = NewsItem(
      id: '2',
      title: 'Plain notice',
      summary: 'No picture attached',
      category: NewsCategory.academic,
      source: 'Eduvora',
      publishedAt: DateTime(2026, 9, 27),
    );
    expect(item.hasImage, isFalse);
  });

  test(
    'CommunityPost carries the pinned-announcement flag and a picture '
    'through a JSON round trip',
    () {
      final CommunityPost post = CommunityPost(
        id: '1',
        authorId: 'owner',
        authorName: 'Eduvora',
        body: 'A pinned scholarship notice',
        topic: CommunityTopic.scholarships,
        createdAt: DateTime(2026, 9, 27),
        isAnnouncement: true,
        imageUrl: 'https://example.com/flyer.png',
      );
      expect(post.hasImage, isTrue);

      final CommunityPost restored = CommunityPost.fromJson(post.toJson());
      expect(restored.isAnnouncement, isTrue);
      expect(restored.imageUrl, 'https://example.com/flyer.png');
    },
  );

  test('an ordinary student post defaults to not pinned', () {
    final CommunityPost post = CommunityPost(
      id: '2',
      authorId: 'student',
      authorName: 'A student',
      body: 'Anyone free for a study session?',
      topic: CommunityTopic.general,
      createdAt: DateTime(2026, 9, 27),
    );
    expect(post.isAnnouncement, isFalse);
    expect(post.hasImage, isFalse);
  });
}
