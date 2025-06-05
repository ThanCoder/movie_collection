import 'package:flutter/material.dart';
import 'package:movie_collections/app/enums/movie_info_types.dart';
import 'package:movie_collections/app/extensions/string_extension.dart';

class MovieInfoTypeChooser extends StatelessWidget {
  MovieInfoTypes type;

  void Function(MovieInfoTypes type) onChoosed;
  MovieInfoTypeChooser({
    super.key,
    required this.type,
    required this.onChoosed,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<MovieInfoTypes>(
      padding: const EdgeInsets.all(5),
      borderRadius: BorderRadius.circular(5),
      value: type,
      items: MovieInfoTypes.values
          .map(
            (mt) => DropdownMenuItem<MovieInfoTypes>(
              value: mt,
              child: Text(mt.name.toCaptalize()),
            ),
          )
          .toList(),
      onChanged: (value) {
        onChoosed(value!);
      },
    );
  }
}
