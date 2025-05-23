import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mc_v2/models/video_item.dart';
import 'package:mc_v2/models/video_type.dart';
import 'package:mc_v2/screens/content/my_listener/content_screen_event_listener.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:than_pkg/enums/screen_orientation_types.dart';
import 'package:than_pkg/than_pkg.dart';

class VideoPlayer extends StatefulWidget {
  VideoItem video;
  VideoPlayer({super.key, required this.video});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer>
    with ContentScreenEventListener {
  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);
  int width = 0;
  int height = 0;

  @override
  void initState() {
    ContentScreenEventSender.instance.addListener(this);
    super.initState();
    final video = widget.video;
    if (video.type == VideoType.series) {
      if (video.seasons.isNotEmpty && video.seasons.first.episodes.isNotEmpty) {
        play(video.seasons.first.episodes.first.filePath);
      }
    } else {
      play(video.filePath);
    }
  }

  void play(String source) async {
    await player.open(Media(source), play: true);
    player.stream.height.listen((vH) {
      width = player.state.width ?? 0;
      height = vH ?? 0;
      setState(() {});
    });
  }

  @override
  void onPageChanged(String? pageName) {
    player.stop();
  }

  @override
  void onPlayVideoPlayer(String source) {
    play(source);
  }

  @override
  void dispose() {
    ContentScreenEventSender.instance.removeListener(this);
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
                return;
              }
              // return;
            }
            await defaultEnterNativeFullscreen();
          },
          onExitFullscreen: () async {
            if (height > width) {
              if (Platform.isAndroid) {
                await ThanPkg.android.app.hideFullScreen();
                await ThanPkg.android.app
                    .requestOrientation(type: ScreenOrientationTypes.Portrait);
                return;
              }
              // return;
            }
            await defaultExitNativeFullscreen();
          },
        ),
      ),
    );
  }
}
