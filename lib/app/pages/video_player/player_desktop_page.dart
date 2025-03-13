import 'dart:io';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';
import 'package:than_pkg/enums/screen_orientation_types.dart';
import 'package:than_pkg/than_pkg.dart';

import '../../notifiers/app_notifier.dart';

class PlayerDesktopPage extends StatefulWidget {
  const PlayerDesktopPage({super.key});

  @override
  State<PlayerDesktopPage> createState() => _PlayerDesktopPageState();
}

class _PlayerDesktopPageState extends State<PlayerDesktopPage> {
  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  List<MovieModel> list = [];
  int currentPos = 0;

  void init() async {
    try {
      final provider = context.read<MovieProvider>();
      final movie = provider.getCurrent!;

      List<MovieModel> movieTypedList = [];

      if (appConfigNotifier.value.isOnlyShowExistsMovieFile) {
        final existsList =
            provider.getList.where((vd) => File(vd.path).existsSync()).toList();

        //type splite
        movieTypedList =
            existsList.where((mv) => mv.type == movie.type).toList();
      } else {
        movieTypedList =
            provider.getList.where((mv) => mv.type == movie.type).toList();
      }

      setState(() {
        list = movieTypedList;
        currentPos = movieTypedList.indexWhere((vd) => vd.id == movie.id);
      });

      final medias = list.map((mv) => Media(mv.path)).toList();
      // await player.open(Media(movie.path), play: true);
      await player.open(
        Playlist(medias, index: currentPos),
        play: true,
      );
      player.stream.playlist.listen((ev) {
        setState(() {
          currentPos = ev.index;
        });
      });
      _scrollTo(currentPos, 142);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String _getDescText() {
    final provider = context.read<MovieProvider>();
    final movie = provider.getCurrent!;
    return movie.content;
  }

  void _scrollTo(int index, double itemHeight) {
    scrollController.animateTo(
      index * itemHeight,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
  }

  Widget _getVideoList() {
    return ListView.builder(
      controller: scrollController,
      itemCount: list.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 5),
        child: MovieListItem(
          isActiveColor: true,
          currentIndex: index,
          activeIndex: currentPos,
          movie: list[index],
          onClicked: (movie, itemHeight) {
            setState(() {
              currentPos = index;
            });
            player.jump(currentPos);
            print(itemHeight);
            // _scrollTo(index, itemHeight);
          },
        ),
      ),
    );
  }

  Widget _getDescWidget({double maxHeight = 250, double minHeight = 100}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight, minHeight: minHeight),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpandableText(
            _getDescText(),
            expandText: 'Read More',
            collapseText: 'Read Less',
            collapseOnTextTap: true,
            maxLines: 3,
            linkColor: Colors.blue,
            urlStyle: TextStyle(color: Colors.blueAccent),
            linkStyle: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }

  Widget _getVideo() {
    return Video(
      controller: controller,
      onEnterFullscreen: () async {
        final height = player.state.height ?? 0;
        final width = player.state.width ?? 0;
        if (height > width) {
          if (Platform.isAndroid) {
            await ThanPkg.android.app
                .requestOrientation(type: ScreenOrientationTypes.Portrait);
            return;
          }
        }
        await defaultEnterNativeFullscreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      contentPadding: 0,
      appBar: AppBar(
        title: Text(''),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Expanded(
            child: Column(
              spacing: 10,
              children: [
                Expanded(
                  child: _getVideo(),
                ),
                //desc
                _getDescWidget(),
              ],
            ),
          ),
          SizedBox(
            width: 400,
            child: _getVideoList(),
          ),
        ],
      ),
    );
  }
}
