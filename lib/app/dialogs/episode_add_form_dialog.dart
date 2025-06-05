import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/enums/movie_info_types.dart';
import 'package:movie_collections/app/extensions/string_extension.dart';

class EpisodeAddFormDialog extends StatefulWidget {
  void Function(MovieInfoTypes movieInfoType) onSubmited;
  EpisodeAddFormDialog({super.key, required this.onSubmited});

  @override
  State<EpisodeAddFormDialog> createState() => _EpisodeAddFormDialogState();
}

class _EpisodeAddFormDialogState extends State<EpisodeAddFormDialog> {
  MovieInfoTypes movieInfoType = MovieInfoTypes.info;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose Types'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            widget.onSubmited(movieInfoType);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
