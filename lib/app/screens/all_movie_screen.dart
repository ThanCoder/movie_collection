import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/movie_grid_item.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/screens/index.dart';
import 'package:provider/provider.dart';
import 'package:real_path_file_selector/ui/widgets/index.dart';

class AllMovieScreen extends StatelessWidget {
  String title;
  List<MovieModel> list;
  AllMovieScreen({super.key, required this.list, required this.title});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      contentPadding: 2,
      appBar: AppBar(
        title: Text(title),
      ),
      body: GridView.builder(
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
              context.read<MovieProvider>().setCurrent(movie);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieContentScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
