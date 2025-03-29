import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/movie_grid_item.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/screens/movie_player_screen.dart';
import 'package:provider/provider.dart';
import 'package:real_path_file_selector/ui/widgets/index.dart';

class AllMovieScreen extends StatefulWidget {
  String title;
  List<MovieModel> list;
  AllMovieScreen({super.key, required this.list, required this.title});

  @override
  State<AllMovieScreen> createState() => _AllMovieScreenState();
}

class _AllMovieScreenState extends State<AllMovieScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      contentPadding: 2,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        itemCount: widget.list.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisExtent: 200,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          final movie = widget.list[index];
          return MovieGridItem(
            movie: movie,
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
          );
        },
      ),
    );
  }
}
