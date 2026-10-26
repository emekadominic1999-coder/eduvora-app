import 'package:eduvora/core/models/academic_video.dart';
import 'package:flutter_test/flutter_test.dart';

AcademicVideo _v(String url, {String thumb = ''}) => AcademicVideo(
  id: '1',
  title: 't',
  department: 'd',
  level: '100',
  videoUrl: url,
  thumbnail: thumb,
);

void main() {
  test('reads the id from every common YouTube link form', () {
    expect(_v('https://youtu.be/unj6F67CV_w').youtubeId, 'unj6F67CV_w');
    expect(_v('https://youtu.be/unj6F67CV_w?si=abc').youtubeId, 'unj6F67CV_w');
    expect(
      _v('https://www.youtube.com/watch?v=unj6F67CV_w&t=30s').youtubeId,
      'unj6F67CV_w',
    );
    expect(
      _v('https://m.youtube.com/watch?v=unj6F67CV_w').youtubeId,
      'unj6F67CV_w',
    );
    expect(
      _v('https://www.youtube.com/shorts/unj6F67CV_w').youtubeId,
      'unj6F67CV_w',
    );
    expect(
      _v('https://www.youtube.com/embed/unj6F67CV_w').youtubeId,
      'unj6F67CV_w',
    );
  });

  test('ignores non-YouTube links and malformed ids', () {
    expect(_v('https://example.com/lecture.mp4').youtubeId, isNull);
    expect(_v('https://www.youtube.com/watch?v=short').youtubeId, isNull);
    expect(_v('https://www.youtube.com/@Eduvora').youtubeId, isNull);
    expect(_v('not a url').youtubeId, isNull);
  });

  test('uses YouTube thumbnail only when none is stored', () {
    expect(
      _v('https://youtu.be/unj6F67CV_w').thumbnailUrl,
      'https://i.ytimg.com/vi/unj6F67CV_w/hqdefault.jpg',
    );
    expect(
      _v('https://youtu.be/unj6F67CV_w', thumb: 'x.png').thumbnailUrl,
      'x.png',
    );
    expect(_v('https://example.com/a.mp4').thumbnailUrl, '');
  });
}
