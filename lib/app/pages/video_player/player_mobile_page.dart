import 'dart:io';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/services/index.dart';
import 'package:movie_collections/app/services/movie_services.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';
import 'package:than_pkg/enums/screen_orientation_types.dart';
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
  bool isResumed = true;

  void init() async {
    try {
      final provider = context.read<MovieProvider>();
      final movie = provider.getCurrent!;
      //check resume music ဆိုရင် resume mode မပေးဘူး
      if (movie.type == MovieTypes.music.name) {
        isResumed = false;
      } else {
        isResumed = true;
      }
      final existsList =
          provider.getList.where((vd) => File(vd.path).existsSync()).toList();
      //type splite
      final movieTypedList =
          existsList.where((mv) => mv.type == movie.type).toList();
      setState(() {
        list = movieTypedList;
        currentPos = movieTypedList.indexWhere((vd) => vd.id == movie.id);
      });

      final medias = list.map((mv) => Media(mv.path)).toList();
      // await player.open(Media(movie.path), play: true);
      await player.open(
        Playlist(medias, index: currentPos),
        play: false,
      );
      player.stream.playlist.listen((ev) {
        setState(() {
          currentPos = ev.index;
        });
      });
      _play();
      //go item
      _scrollTo(currentPos, 145);
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

  Future<void> _setPosition() async {
    if (!isResumed) return;
    final movie = context.read<MovieProvider>().getCurrent!;
    await MovieServices.instance
        .setPosition(movie: movie, duration: player.state.position.inSeconds);
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
            RecentMovieServices.instance.add(movieId: movie.id);
            _scrollTo(index, itemHeight);
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
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        await _setPosition();
      },
      child: MyScaffold(
        contentPadding: 0,
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: Platform.isLinux,
              expandedHeight: 200,
              collapsedHeight: 200,
              floating: true,
              pinned: true,
              flexibleSpace: SafeArea(child: _getVideo()),
            ),
            //desc
            SliverToBoxAdapter(
              child: _getDescText().isEmpty
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpandableText(
                        _getDescText(),
                        expandText: 'Read More',
                        collapseText: 'Read Less',
                        collapseOnTextTap: true,
                        maxLines: 3,
                        linkColor: Colors.blue,
                      ),
                    ),
            ),

            SliverToBoxAdapter(
              child: Divider(),
            ),

            //list
            SliverList.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(bottom: 5),
                child: MovieListItem(
                  isActiveColor: true,
                  currentIndex: index,
                  activeIndex: currentPos,
                  movie: list[index],
                  onClicked: (movie, itemHeight) async {
                    setState(() {
                      currentPos = index;
                    });
                    await _setPosition();
                    await player.jump(currentPos);
                    await _play();

                    _scrollTo(index, itemHeight);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
