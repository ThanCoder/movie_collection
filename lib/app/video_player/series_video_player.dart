// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_collections/app/providers/series_video_player_provider.dart';
import 'package:movie_collections/app/services/movie_season_services.dart';
import 'package:provider/provider.dart';
import 'package:than_pkg/than_pkg.dart';

class SeriesVideoPlayer extends StatefulWidget {
  const SeriesVideoPlayer({super.key});

  @override
  State<SeriesVideoPlayer> createState() => _SeriesVideoPlayerState();
}

class _SeriesVideoPlayerState extends State<SeriesVideoPlayer> {
  late final player = Player();
  late final controller = VideoController(player);
  final ScrollController scrollController = ScrollController();

  late SeriesVideoPlayerProvider _seriesVideoPlayerProvider;

  @override
  void initState() {
    _seriesVideoPlayerProvider = context.read<SeriesVideoPlayerProvider>();
    _seriesVideoPlayerProvider.addListener(_providerListener);
    super.initState();
    init();
  }

  void init() async {
    final provider = context.read<SeriesVideoPlayerProvider>();

    // final medias = provider.list
    //     .map((ep) =>
    //         Media(MovieSeasonServices.getVideoPath(provider.movieId, ep)))
    //     .toList();
    // await player.open(Playlist(medias), play: true);
    if (provider.list.isEmpty) return;
    final path = MovieSeasonServices.getVideoPath(
      provider.movieId,
      provider.list[provider.currentIndex],
    );
    await player.open(Media(path), play: true);
  }

  void _providerListener() async {
    final provider = context.read<SeriesVideoPlayerProvider>();
    final episode = provider.currentEpisode;
    if (episode == null) return;
    final path = MovieSeasonServices.getVideoPath(provider.movieId, episode);
    await player.open(Media(path), play: true);
  }

  @override
  void dispose() {
    player.dispose();
    _seriesVideoPlayerProvider.removeListener(_providerListener);
    if (Platform.isAndroid) {
      ThanPkg.android.app.hideFullScreen();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final episode = context.watch<SeriesVideoPlayerProvider>().currentEpisode;
    return Column(
      children: [
        episode == null
            ? SizedBox.shrink()
            : Text(
                '${episode.episodeNumber}: ${episode.title}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
        Expanded(
          child: Video(
            controller: controller,
            width: size.width,
            // height: size.height,
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
          ),
        ),
      ],
    );
  }
}
