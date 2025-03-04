import 'package:flutter/material.dart';
import 'package:movie_collections/app/enums/movie_types.dart';

class MovieTypeChooser extends StatelessWidget {
  MovieTypes type;
  void Function(MovieTypes type) onChoosed;
  MovieTypeChooser({
    super.key,
    required this.type,
    required this.onChoosed,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<MovieTypes>(
      padding: const EdgeInsets.all(5),
      borderRadius: BorderRadius.circular(5),
      value: type,
      items: MovieTypes.values
          .map(
            (mt) => DropdownMenuItem<MovieTypes>(
              value: mt,
              child: Text(mt.name),
            ),
          )
          .toList(),
      onChanged: (value) {
        onChoosed(value!);
      },
    );
  }
}
