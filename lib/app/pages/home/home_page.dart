import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/components/movie_see_all_view.dart';
import 'package:movie_collections/app/customs/movie_search_delegate.dart';
import 'package:movie_collections/app/dialogs/movie_type_chooser_dialog.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/extensions/index.dart';
import 'package:movie_collections/app/general_server/index.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/routes_helper.dart';
import 'package:movie_collections/app/screens/movie_player_screen.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../widgets/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> init({bool isReset = false}) async {
    await context.read<MovieProvider>().initList(isReset: isReset);
  }

  void _addMovieFilePath(List<DropItem> items) {
    final pathList = items
        .where((item) => (lookupMimeType(item.path) ?? '').startsWith('video'))
        .map((item) => item.path)
        .toList();
    if (pathList.isEmpty) return;
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MovieTypeChooserDialog(
        onSubmited:
            (MovieTypes movieType, MovieInfoTypes movieInfoType, String tags) {
          if (!mounted) return;

          context.read<MovieProvider>().addFromPathList(
              pathList: pathList,
              movieInfoType: movieInfoType,
              movieType: movieType,
              tags: tags);
        },
      ),
    );
  }

  void _goContentScreen(MovieModel movie) async {
    await context.read<MovieProvider>().setCurrent(movie);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoviePlayerScreen(),
      ),
    );
  }

  Widget _getRefreshWidget() {
    return Center(
      child: Column(
        spacing: 3,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              'List Empty... ${PlatformExtension.isDesktop() ? '\nFile Drop Here...' : ''}'),
          IconButton(
            color: Colors.blue,
            onPressed: () async {
              await context.read<MovieProvider>().initList(isReset: true);
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  void _goAllScreen(String title, List<MovieModel> list) {
    goResultScreen(context, title: title, list: list);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final list = provider.getList;
    final isLoading = provider.isLoading;
    final movieList =
        list.where((mv) => mv.type == MovieTypes.movie.name).toList();
    final seriesList =
        list.where((mv) => mv.type == MovieTypes.series.name).toList();
    final musicList =
        list.where((mv) => mv.type == MovieTypes.music.name).toList();
    final pornList =
        list.where((mv) => mv.type == MovieTypes.porns.name).toList();
    final randomList = List.of(list);
    randomList.shuffle();

    Widget _getSeeAllWidgets() {
      return SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            //random
            MovieSeeAllView(
              title: 'Random',
              showLines: 1,
              list: randomList,
              onClicked: _goContentScreen,
              onSeeAllClicked: _goAllScreen,
            ),
            //latest
            MovieSeeAllView(
              title: 'Latest Movie',
              list: list,
              onClicked: _goContentScreen,
              onSeeAllClicked: _goAllScreen,
            ),
            //Movie
            MovieSeeAllView(
              title: 'Movie',
              list: movieList,
              onClicked: _goContentScreen,
              onSeeAllClicked: _goAllScreen,
            ),
            //Movie
            MovieSeeAllView(
              title: 'Series',
              list: seriesList,
              onClicked: _goContentScreen,
              onSeeAllClicked: _goAllScreen,
            ),
            //Music
            MovieSeeAllView(
              title: 'Music',
              list: musicList,
              onClicked: _goContentScreen,
              onSeeAllClicked: _goAllScreen,
            ),
            //Porns
            MovieSeeAllView(
              title: 'Porns',
              list: pornList,
              onClicked: _goContentScreen,
              onSeeAllClicked: _goAllScreen,
            ),
          ],
        ),
      );
    }

    return MyScaffold(
      contentPadding: 2,
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          GeneralServerNotiButton(),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(
                  onClicked: _goContentScreen,
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
          Platform.isLinux
              ? IconButton(
                  onPressed: () async {
                    await init(isReset: true);
                  },
                  icon: Icon(Icons.refresh),
                )
              : SizedBox.shrink(),
          MovieAddActionButton(),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: isHomePageDropableNotifier,
          builder: (context, value, child) {
            return DropTarget(
              enable: true,
              onDragDone: (details) {
                _addMovieFilePath(details.files);
              },
              child: isLoading
                  ? TLoader()
                  : list.isEmpty
                      ? _getRefreshWidget()
                      : RefreshIndicator(
                          onRefresh: () async {
                            await init(isReset: true);
                          },
                          child: _getSeeAllWidgets(),
                        ),
            );
          }),
    );
  }
}
