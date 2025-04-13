import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:movie_collections/app/components/drop_filepath_container.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/customs/movie_search_delegate.dart';
import 'package:movie_collections/app/dialogs/movie_type_chooser_dialog.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/extensions/index.dart';
import 'package:movie_collections/app/general_server/index.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/screens/all_movie_screen.dart';
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

  Future<void> init() async {
    await context.read<MovieProvider>().initList();
  }

  void addMovieFilePath(List<DropItem> items) {
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

  Widget dropFilepathContainerListenable({required Widget child}) {
    return ValueListenableBuilder(
      valueListenable: isHomePageDropableNotifier,
      builder: (context, isEnable, _child) {
        return DropFilepathContainer(
          onDroped: isEnable ? addMovieFilePath : null,
          child: child,
        );
      },
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
            MovieSeeAllListView(
              title: 'Random',
              list: randomList,
              onClicked: _goContentScreen,
              onSeeAllClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllMovieScreen(
                      list: randomList,
                      title: 'Random',
                    ),
                  ),
                );
              },
            ),
            //latest
            MovieSeeAllListView(
              title: 'Latest Movie',
              list: list,
              onClicked: _goContentScreen,
              onSeeAllClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllMovieScreen(
                      list: list,
                      title: 'Latest Movie',
                    ),
                  ),
                );
              },
            ),
            //Movie
            MovieSeeAllListView(
              title: 'Movie',
              list: movieList,
              onClicked: _goContentScreen,
              onSeeAllClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllMovieScreen(title: 'Latest Movie', list: movieList),
                  ),
                );
              },
            ),
            //Movie
            MovieSeeAllListView(
              title: 'Series',
              list: seriesList,
              onClicked: _goContentScreen,
              onSeeAllClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllMovieScreen(title: 'Latest Movie', list: seriesList),
                  ),
                );
              },
            ),
            //Music
            MovieSeeAllListView(
              title: 'Music',
              list: musicList,
              onClicked: _goContentScreen,
              onSeeAllClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllMovieScreen(title: 'Latest Music', list: musicList),
                  ),
                );
              },
            ),
            //Porns
            MovieSeeAllListView(
              title: 'Porns',
              list: pornList,
              onClicked: _goContentScreen,
              onSeeAllClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllMovieScreen(title: 'Latest Porns', list: pornList),
                  ),
                );
              },
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
                    await context.read<MovieProvider>().initList(isReset: true);
                  },
                  icon: Icon(Icons.refresh),
                )
              : SizedBox.shrink(),
          MovieAddActionButton(),
        ],
      ),
      body: dropFilepathContainerListenable(
        child: isLoading
            ? TLoader()
            : list.isEmpty
                ? _getRefreshWidget()
                : RefreshIndicator(
                    onRefresh: () async {
                      await init();
                    },
                    child: _getSeeAllWidgets(),
                  ),
      ),
    );
  }
}
