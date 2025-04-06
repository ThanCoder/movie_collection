import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  late List<MovieModel> list;
  void Function(MovieModel movie) onClicked;
  MovieSearchDelegate({
    required this.onClicked,
  }) {
    list = MovieProvider.getDB.values.toList();
  }
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear_all_rounded),
      ),
    ];
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
    // ..sort((a, b) {
    //   final aI = a.title.toLowerCase().indexOf(query.toLowerCase());
    //   final bI = b.title.toLowerCase().indexOf(query.toLowerCase());
    //   return aI.compareTo(bI);
    // });
    if (res.isEmpty) {
      return Center(child: Text('မရှိပါ....'));
    }

    return ListView.builder(
      itemCount: res.length,
      itemBuilder: (context, index) {
        return MovieListItem(
          movie: res[index],
          onClicked: (movie, itemHeight) => onClicked(movie),
        );
      },
    );
  }
}
