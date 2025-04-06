import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/movie_model.dart';

class MovieTagList extends StatelessWidget {
  MovieModel movie;
  void Function(String name)? onClicked;
  MovieTagList({
    super.key,
    required this.movie,
    this.onClicked,
  });

  List<String> _getList() {
    return movie.tags.split(',').where((name) => name.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: List.generate(
        _getList().length,
        (index) {
          final name = _getList()[index];
          return GestureDetector(
            onTap: () {
              if (onClicked != null) {
                onClicked!(name);
              }
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.all(5),
                child: Text(
                  '#$name',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
