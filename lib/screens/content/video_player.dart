import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mc_v2/models/video_item.dart';
import 'package:mc_v2/screens/content/my_listener/page_navi_listener.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:than_pkg/than_pkg.dart';

class VideoPlayer extends StatefulWidget {
  VideoItem video;
  VideoPlayer({super.key, required this.video});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> with PageNaviListener {
  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);
  int width = 0;
  int height = 0;

  @override
  void initState() {
    PageNaviSubject.instance.addListener(this);
    super.initState();
    init();
    // Play a [Media] or [Playlist].
    // player.open(Media('https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4'));
  }

  @override
  void onPageChanged() {
    player.pause();
  }

  void init() async {
    await player.open(Media(widget.video.filePath), play: true);
    width = player.state.width ?? 0;
    height = player.state.height ?? 0;
    setState(() {});
  }

  @override
  void dispose() {
    PageNaviSubject.instance.removeListener(this);
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 9.0 / 16.0,
        // Use [Video] widget to display video output.
        child: Video(
          controller: controller,
          onEnterFullscreen: () async {
            if (height > width) {
              if (Platform.isAndroid) {
                ThanPkg.android.app.showFullScreen();
              }
              return;
            }
            await defaultEnterNativeFullscreen();
          },
          onExitFullscreen: () async {
            if (height > width) {
              if (Platform.isAndroid) {
                ThanPkg.android.app.hideFullScreen();
              }
              return;
            }
            await defaultExitNativeFullscreen();
          },
        ),
      ),
    );
  }
}
