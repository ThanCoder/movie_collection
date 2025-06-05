import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/movie_grid_item.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/screens/movie_player_screen.dart';
import 'package:movie_collections/app/services/index.dart';
import 'package:provider/provider.dart';
import 'package:real_path_file_selector/ui/widgets/index.dart';

class AllBookmarkMovieScreen extends StatefulWidget {
  const AllBookmarkMovieScreen({super.key});

  @override
  State<AllBookmarkMovieScreen> createState() => _AllBookmarkMovieScreenState();
}

class _AllBookmarkMovieScreenState extends State<AllBookmarkMovieScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      contentPadding: 2,
      appBar: AppBar(
        title: Text('Book Mark'),
      ),
      body: Consumer<BookmarkServices>(
        builder: (context, book, child) {
          return FutureBuilder(
            future: BookmarkServices.instance.getMovieList(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return TLoader();
              }
              final list = snapshot.data ?? [];
              return GridView.builder(
                itemCount: list.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180,
                  mainAxisExtent: 200,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  final movie = list[index];
                  return MovieGridItem(
                    movie: movie,
                    onClicked: (movie) async {
                      await context.read<MovieProvider>().setCurrent(movie);
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoviePlayerScreen(),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
