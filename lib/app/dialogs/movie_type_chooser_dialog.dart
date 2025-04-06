import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/components/tag_list_chooser.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/extensions/string_extension.dart';

class MovieTypeChooserDialog extends StatefulWidget {
  void Function(MovieTypes movieType, MovieInfoTypes movieInfoType, String tags)
      onSubmited;
  MovieTypeChooserDialog({super.key, required this.onSubmited});

  @override
  State<MovieTypeChooserDialog> createState() => _MovieTypeChooserDialogState();
}

class _MovieTypeChooserDialogState extends State<MovieTypeChooserDialog> {
  MovieTypes movieType = MovieTypes.movie;
  MovieInfoTypes movieInfoType = MovieInfoTypes.info;
  String tags = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Movie Types ရွေးချယ်ပါ'),
      content: SingleChildScrollView(
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text('Choose Tags'),
            TagListChooser(
              tags: tags,
              onChanged: (String value) {
                setState(() {
                  tags = value;
                });
              },
            ),
            // info
            Text(
                '${MovieInfoTypes.info.name.toCaptalize()} -> movie file အချက်အလက်ပဲ ရယူမယ်'),
            Text(
                '${MovieInfoTypes.data.name.toCaptalize()} -> movie file ကိုပါ ရွှေ့မယ်'),
            // Text('info -> movie file '),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onSubmited(movieType, movieInfoType, tags);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
