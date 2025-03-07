import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/models/index.dart';

class MovieSearchDelegate extends SearchDelegate {
  List<MovieModel> list;
  void Function(MovieModel movie) onClicked;
  MovieSearchDelegate({
    required this.list,
    required this.onClicked,
  });
  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) => _getResult();

  @override
  Widget buildSuggestions(BuildContext context) => _getResult();

  Widget _getResult() {
    if (query.isEmpty) {
      return Center(child: Text('တစ်ခုခုရေးပါ....'));
    }
    final res = list
        .where((mv) => mv.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (res.isEmpty) {
      return Center(child: Text('မရှိပါ....'));
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return MovieListItem(
          movie: list[index],
          onClicked: (movie, itemHeight) => onClicked(movie),
        );
      },
    );
  }
}
