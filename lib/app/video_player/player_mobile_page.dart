import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/services/index.dart';
import 'package:provider/provider.dart';
import 'package:than_pkg/than_pkg.dart';

class PlayerMobilePage extends StatefulWidget {
  const PlayerMobilePage({super.key});

  @override
  State<PlayerMobilePage> createState() => _PlayerMobilePageState();
}

class _PlayerMobilePageState extends State<PlayerMobilePage> {
  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    player.dispose();
    if (Platform.isAndroid) {
      ThanPkg.android.app.hideFullScreen();
    }
    super.dispose();
  }

  bool isResumed = true;

  void init() async {
    try {
      final provider = context.read<MovieProvider>();
      final movie = provider.getCurrent!;

      await player.open(Media(movie.path), play: true);
      _play();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _play() async {
    final movie = context.read<MovieProvider>().getCurrent!;
    if (isResumed) {
      final dur = await MovieServices.instance.getPosition(movie: movie);
      await Future.delayed(Duration(milliseconds: 500));
      if (dur != 0) {
        player.seek(Duration(seconds: dur));
      }
    }
    await player.play();
    RecentMovieServices.instance.add(movieId: movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Video(
      controller: controller,
      width: 100,
      height: 200,
      onEnterFullscreen: () async {
        final height = player.state.height ?? 0;
        final width = player.state.width ?? 0;
        if (height > width) {
          if (Platform.isAndroid) {
            await ThanPkg.android.app.showFullScreen();
            return;
          }
        }
        await defaultEnterNativeFullscreen();
      },
      onExitFullscreen: () async {
        if (Platform.isAndroid) {
          await ThanPkg.android.app.hideFullScreen();
        }
        await defaultExitNativeFullscreen();
      },
    );
  }
}
