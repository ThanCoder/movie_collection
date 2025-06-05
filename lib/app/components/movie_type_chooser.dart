import 'package:flutter/material.dart';
import 'package:movie_collections/app/enums/movie_types.dart';
import 'package:movie_collections/app/extensions/string_extension.dart';

class MovieTypeChooser extends StatelessWidget {
  MovieTypes type;
  bool isShowSeriesType;
  void Function(MovieTypes type) onChoosed;
  MovieTypeChooser({
    super.key,
    required this.type,
    this.isShowSeriesType = false,
    required this.onChoosed,
  });

  List<MovieTypes> _getTypeList() {
    if (isShowSeriesType) {
      return MovieTypes.values;
    }
    return MovieTypes.values.where((ty) => ty != MovieTypes.series).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<MovieTypes>(
      padding: const EdgeInsets.all(5),
      borderRadius: BorderRadius.circular(5),
      value: type,
      items: _getTypeList()
          .map(
            (mt) => DropdownMenuItem<MovieTypes>(
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
