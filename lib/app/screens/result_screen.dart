import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/movie_grid_item.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/screens/movie_player_screen.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: resultScreenDataNotifier,
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(value.title),
            ),
            body: GridView.builder(
              itemCount: value.list.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                mainAxisExtent: 200,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                final movie = value.list[index];
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
            ),
          );
        });
  }
}
