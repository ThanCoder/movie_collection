import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/enums/index.dart';

class MovieTypeChooserDialog extends StatefulWidget {
  void Function(MovieTypes movieType, MovieInfoTypes movieInfoType) onSubmited;
  MovieTypeChooserDialog({super.key, required this.onSubmited});

  @override
  State<MovieTypeChooserDialog> createState() => _MovieTypeChooserDialogState();
}

class _MovieTypeChooserDialogState extends State<MovieTypeChooserDialog> {
  MovieTypes movieType = MovieTypes.movie;
  MovieInfoTypes movieInfoType = MovieInfoTypes.info;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Movie Types ရွေးချယ်ပါ'),
      content: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            Row(
              spacing: 5,
              children: [
                Text('Movie Type'),
                MovieTypeChooser(
                  type: movieType,
                  onChoosed: (type) {
                    setState(() {
                      movieType = type;
                    });
                  },
                ),
              ],
            ),
            Row(
              spacing: 5,
              children: [
                Text('Movie Info Type'),
                MovieInfoTypeChooser(
                  type: movieInfoType,
                  onChoosed: (type) {
                    setState(() {
                      movieInfoType = type;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onSubmited(movieType, movieInfoType);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
