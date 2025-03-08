import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/customs/movie_search_delegate.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/screens/all_movie_screen.dart';
import 'package:movie_collections/app/screens/movie_content_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final list = provider.getList;
    final isLoading = provider.isLoading;
    final movieList =
        list.where((mv) => mv.type == MovieTypes.movie.name).toList();
    final musicList =
        list.where((mv) => mv.type == MovieTypes.music.name).toList();
    final pornList =
        list.where((mv) => mv.type == MovieTypes.porns.name).toList();
    // final musicList = list.where((mv) => mv.type == MovieTypes.series.name).toList();

    void _goContentScreen(MovieModel movie) {
      context.read<MovieProvider>().setCurrent(movie);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieContentScreen(),
        ),
      );
    }

    return MyScaffold(
      contentPadding: 2,
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(
                  list: list,
                  onClicked: _goContentScreen,
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
          MovieAddActionButton(),
        ],
      ),
      body: isLoading
          ? TLoader()
          : RefreshIndicator.adaptive(
              onRefresh: () async {
                await init();
              },
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  children: [
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
                            builder: (context) => AllMovieScreen(
                                title: 'Latest Movie', list: movieList),
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
                            builder: (context) => AllMovieScreen(
                                title: 'Latest Music', list: musicList),
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
                            builder: (context) => AllMovieScreen(
                                title: 'Latest Porns', list: pornList),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
