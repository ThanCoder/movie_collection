import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/movie_list_view.dart';
import 'package:movie_collections/app/models/genres_model.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/genres_provider.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/screens/movie_content_screen.dart';
import 'package:movie_collections/app/widgets/t_chip.dart';
import 'package:provider/provider.dart';

class GenresPage extends StatefulWidget {
  const GenresPage({super.key});

  @override
  State<GenresPage> createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  String currentGenresTitle = 'All';
  List<MovieModel> sortedMovies = [];

  void init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GenresProvider>(context, listen: false).initList();
      _sortMovie();
    });
  }

  void _sortMovie() {
    final allMovies =
        Provider.of<MovieProvider>(context, listen: false).getMovieList;
    if (currentGenresTitle == 'All') {
      setState(() {
        sortedMovies = allMovies;
      });
    } else {
      //genres title
      final res = allMovies
          .where((mv) => mv.genres.contains(currentGenresTitle))
          .toList();
      setState(() {
        sortedMovies = res;
      });
    }
  }

  List<Widget> _getGenresWidgets(List<GenresModel> genres) => genres
      .map(
        (gn) => TChip(
          avatar: currentGenresTitle == gn.title ? Icon(Icons.check) : null,
          title: gn.title,
          onClick: () {
            setState(() {
              currentGenresTitle = gn.title;
            });
            _sortMovie();
          },
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GenresProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            TChip(
              avatar: currentGenresTitle == 'All' ? Icon(Icons.check) : null,
              title: 'All',
              onClick: () {
                setState(() {
                  currentGenresTitle = 'All';
                });
                _sortMovie();
              },
            ),
            ..._getGenresWidgets(provider.getList)
          ],
        ),
        Expanded(
          child: MovieListView(
            movieList: sortedMovies,
            onClick: (movie) {
              currentMovieNotifier.value = movie;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieContentScreen(),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
