import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/genres_wrap_view.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/video_player/player_mobile_page.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/screens/all_movie_screen.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

class MoviePlayerScreen extends StatefulWidget {
  const MoviePlayerScreen({super.key});

  @override
  State<MoviePlayerScreen> createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  bool isShowCover = true;

  Widget _getCurrentPlayer() {
    final movie = currentMovieNotifier.value;
    if (movie == null) return const SizedBox.shrink();
    if (isShowCover) {
      return MyImageFile(path: movie.coverPath);
    }
    return PlayerMobilePage();
  }

  Widget _getContent() {
    final movie = currentMovieNotifier.value;
    if (movie == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(movie.title),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 201, 37, 25),
              ),
              onPressed: () {
                setState(() {
                  isShowCover = false;
                });
              },
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'ကြည့်မည်',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            //book mark
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                MovieBookmarkButton(movie: movie),
              ],
            ),
            const Divider(),
            //descritpion
            ExpandableText(
              movie.content,
              expandText: 'See More',
              collapseText: 'See Less',
              maxLines: 4,
              linkColor: Colors.blue,
              collapseOnTextTap: true,
            ),
            //genres
            GenresWrapView(
              title: 'အမျိုးအစားများ',
              genres: movie.type,
              onClicked: (genres) {
                print(genres);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<MovieModel> _getRandomList() {
    final list = List.of(context.read<MovieProvider>().getList);
    final movie = context.read<MovieProvider>().getCurrent;
    if (movie == null) return [];
    list.shuffle();
    return list;
  }

  List<MovieModel> _getRelatedList() {
    final list = context.read<MovieProvider>().getList;
    final movie = context.read<MovieProvider>().getCurrent;
    if (movie == null) return [];
    return list.where((mv) => mv.type == movie.type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      contentPadding: 0,
      appBar: AppBar(
        title: Text('အသေးစိတ်'),
        actions: [
          MovieContentActionButton(
            onDoned: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 200,
            collapsedHeight: 200,
            pinned: true,
            floating: true,
            flexibleSpace: _getCurrentPlayer(),
          ),
          //content
          SliverToBoxAdapter(
            child: _getContent(),
          ),
          //related
          SliverToBoxAdapter(
            child: Card(
              child: MovieSeeAllListView(
                title: 'Related',
                width: 100,
                height: 130,
                fontSize: 10,
                list: _getRelatedList(),
                onClicked: (movie) async {
                  await context.read<MovieProvider>().setCurrent(movie);
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviePlayerScreen(),
                    ),
                  );
                },
                onSeeAllClicked: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllMovieScreen(
                        title: 'Related',
                        list: _getRelatedList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          //random list
          SliverToBoxAdapter(
            child: Card(
              child: MovieSeeAllListView(
                title: 'Random',
                width: 100,
                height: 130,
                fontSize: 10,
                list: _getRandomList(),
                onClicked: (movie) async {
                  await context.read<MovieProvider>().setCurrent(movie);
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviePlayerScreen(),
                    ),
                  );
                },
                onSeeAllClicked: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllMovieScreen(
                        title: 'Random',
                        list: _getRandomList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
