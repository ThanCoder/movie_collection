import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/components/tag_list.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/routes_helper.dart';
import 'package:movie_collections/app/screens/all_bookmark_movie_screen.dart';
import 'package:movie_collections/app/screens/index.dart';
import 'package:movie_collections/app/services/index.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  List<MovieModel> recentList = [];
  List<MovieModel> movieList = [];

  bool isLoading = true;

  void init() async {
    try {
      setState(() {
        isLoading = true;
      });
      movieList = await context.read<MovieProvider>().initList();
      recentList = await RecentMovieServices.instance.getMovieList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      showDialogMessage(context, e.toString());
      debugPrint(e.toString());
    }
  }

  void _goContentScreen(MovieModel movie) {
    context.read<MovieProvider>().setCurrent(movie);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoviePlayerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: isLoading
          ? TLoader()
          : SingleChildScrollView(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //recent
                  MovieSeeAllListView(
                    title: 'Recent Watch',
                    list: recentList,
                    onClicked: _goContentScreen,
                    onSeeAllClicked: () {
                      goResultScreen(context,
                          title: 'Recent Watch', list: recentList);
                    },
                  ),
                  //book mark
                  Consumer<BookmarkServices>(
                    builder: (context, book, child) {
                      return FutureBuilder(
                        future: BookmarkServices.instance.getMovieList(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return TLoader();
                          }
                          final list = snapshot.data ?? [];
                          return MovieSeeAllListView(
                            title: 'BookMark',
                            list: list,
                            onClicked: _goContentScreen,
                            onSeeAllClicked: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AllBookmarkMovieScreen(),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  //tags wap list view
                  Text('Tags'),
                  TagList(),
                ],
              ),
            ),
    );
  }
}
