import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class Videos extends StatefulWidget {
  const Videos({Key key}) : super(key: key);

  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  YoutubePlayerController _controller;

  List<String> video = [
    'nPt8bK2gbaU',
    'K18cpp_-gP8',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: video[0],
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      debugPrint('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      debugPrint('Exited Fullscreen');
    };
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: YoutubePlayerControllerProvider(
        controller: _controller,
        child: Stack(
          fit: StackFit.expand,
          children: [
            player,
            YoutubeValueBuilder(
              controller: _controller,
              builder: (context, value) {
                return AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Material(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            YoutubePlayerController.getThumbnail(
                              videoId: video[1],
                              quality: ThumbnailQuality.high,
                            ),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  crossFadeState: value.isReady
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
