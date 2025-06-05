// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:movie_collections/app/dialogs/tag_form_dialog.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:provider/provider.dart';

class TagListTileButton extends StatefulWidget {
  String values;
  void Function(String values) onChoosed;
  TagListTileButton({
    super.key,
    required this.values,
    required this.onChoosed,
  });

  @override
  State<TagListTileButton> createState() => _TagListTileButtonState();
}

class _TagListTileButtonState extends State<TagListTileButton> {
  void _showTags() {
    showDialog(
      context: context,
      builder: (context) => TagFormDialog(
        values: context.read<MovieProvider>().getCurrent!.tags,
        onSubmited: (values) {
          final movie = context.read<MovieProvider>().getCurrent!;
          movie.tags = values;
          context.read<MovieProvider>().update(movie);
          // context.read<MovieProvider>().setCurrent(movie);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.tag_rounded),
      title: Text('Set Tags'),
      onTap: () {
        Navigator.pop(context);
        _showTags();
      },
    );
  }
}
