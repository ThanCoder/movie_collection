import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/movie_list_view.dart';
import 'package:movie_collections/app/models/movie_model.dart';

class MovieSearchDelegate extends SearchDelegate<MovieModel> {
  final List<MovieModel> movieList;
  void Function(MovieModel movie) onClick;

  MovieSearchDelegate({required this.movieList, required this.onClick});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Please Write Something...'));
    }
    final resultList = movieList
        .where((mv) => mv.title.toUpperCase().contains(query.toUpperCase()))
        .toList();
    return MovieListView(movieList: resultList, onClick: onClick);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Please Write Something...'));
    }
    final resultList = movieList
        .where((mv) => mv.title.toUpperCase().contains(query.toUpperCase()))
        .toList();
    return ListView.separated(
      itemBuilder: (context, index) {
        final movie = resultList[index];
        return ListTile(
          onTap: () => onClick(movie),
          title: Text(movie.title),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: resultList.length,
    );
  }
}
