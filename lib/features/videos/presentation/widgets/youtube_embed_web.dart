import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

/// A plain YouTube embed for the website. The iframe-API player the apps use
/// builds its page inside a data: URL, which has no origin, and in a browser
/// it never reports ready, so the lecture sat on "loading".
class WebYoutubeEmbed extends StatelessWidget {
  const WebYoutubeEmbed({super.key, required this.videoId});

  final String videoId;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: HtmlElementView.fromTagName(
        tagName: 'iframe',
        onElementCreated: (Object element) {
          final web.HTMLIFrameElement frame = element as web.HTMLIFrameElement;
          frame.src =
              'https://www.youtube-nocookie.com/embed/$videoId'
              '?playsinline=1&rel=0&modestbranding=1';
          frame.allow =
              'accelerometer; autoplay; encrypted-media; gyroscope; '
              'picture-in-picture; fullscreen';
          frame.allowFullscreen = true;
          frame.style.border = '0';
          frame.style.width = '100%';
          frame.style.height = '100%';
        },
      ),
    );
  }
}
