import 'package:flutter/widgets.dart';

/// Only the website uses this; the apps play YouTube through the iframe player.
class WebYoutubeEmbed extends StatelessWidget {
  const WebYoutubeEmbed({super.key, required this.videoId});

  final String videoId;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
