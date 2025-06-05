import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_collections/app/enums/movie_info_types.dart';
import 'package:movie_collections/app/models/episode_model.dart';
import 'package:movie_collections/app/widgets/index.dart';

class EpisodeEditFormDialog extends StatefulWidget {
  EpisodeModel episode;
  void Function(EpisodeModel episode) onSubmited;
  EpisodeEditFormDialog(
      {super.key, required this.episode, required this.onSubmited});

  @override
  State<EpisodeEditFormDialog> createState() => _EpisodeEditFormDialogState();
}

class _EpisodeEditFormDialogState extends State<EpisodeEditFormDialog> {
  MovieInfoTypes movieInfoType = MovieInfoTypes.info;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.episode.title;
    numberController.text = widget.episode.episodeNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Episode'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            TTextField(
              controller: titleController,
              isSelectedAll: true,
              label: Text('Title'),
            ),
            TTextField(
              controller: numberController,
              label: Text('Number'),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputType: TextInputType.number,
              isSelectedAll: true,
            ),
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
            widget.episode.title = titleController.text;
            if (int.tryParse(numberController.text) == null) {
              return;
            }
            widget.episode.episodeNumber = int.parse(numberController.text);
            widget.onSubmited(widget.episode);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
