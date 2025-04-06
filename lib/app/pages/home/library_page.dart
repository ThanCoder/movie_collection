import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/components/tag_list.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/screens/index.dart';
import 'package:movie_collections/app/services/index.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

import '../../screens/all_movie_screen.dart';

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
  List<MovieModel> bookmarkList = [];
  bool isLoading = true;

  void init() async {
    try {
      setState(() {
        isLoading = true;
      });
      final list = await context.read<MovieProvider>().initList();
      final bookmark = await BookmarkServices.instance.getList();
      bookmarkList = list.where((vd) => bookmark.contains(vd.id)).toList();
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllMovieScreen(
                              title: 'Recent Watch', list: recentList),
                        ),
                      );
                    },
                  ),
                  //book mark
                  MovieSeeAllListView(
                    title: 'BookMark',
                    list: bookmarkList,
                    onClicked: _goContentScreen,
                    onSeeAllClicked: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllMovieScreen(
                              title: 'BookMark', list: bookmarkList),
                        ),
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
