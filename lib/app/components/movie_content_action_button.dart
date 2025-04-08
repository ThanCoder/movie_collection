import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/tag_list_tile_button.dart';
import 'package:movie_collections/app/dialogs/core/index.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/extensions/datetime_extension.dart';
import 'package:movie_collections/app/extensions/double_extension.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/screens/index.dart';
import 'package:movie_collections/app/screens/movie_series_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:than_pkg/than_pkg.dart';

class MovieContentActionButton extends StatefulWidget {
  VoidCallback onDoned;
  MovieContentActionButton({super.key, required this.onDoned});

  @override
  State<MovieContentActionButton> createState() =>
      _MovieContentActionButtonState();
}

class _MovieContentActionButtonState extends State<MovieContentActionButton> {
  void _deleteConfirm() {
    final movie = context.read<MovieProvider>().getCurrent!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmDialog(
        contentText: '`${movie.title}` ကိုဖျက်ချင်တာ သေချာပြီလား',
        submitText: 'Delete',
        onCancel: () {},
        onSubmit: () async {
          await context.read<MovieProvider>().delete(movie);
          widget.onDoned();
        },
      ),
    );
  }

  void _goEdit() {
    final movie = context.read<MovieProvider>().getCurrent!;
    if (movie.type == MovieTypes.series.name) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieSeriesFormScreen(),
        ),
      );
      return;
    }
    //
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieFormScreen(),
      ),
    );
  }

  void _restore() {
    final movie = context.read<MovieProvider>().getCurrent!;
    context.read<MovieProvider>().restoreMovieFile(
      context,
      movie: movie,
      onDoned: () {
        Navigator.pop(context);
      },
    );
  }

  void _openAnother() async {
    try {
      final movie = context.read<MovieProvider>().getCurrent!;
      if (Platform.isAndroid) {
        await ThanPkg.android.app.openVideoWithIntent(path: movie.path);
      }
      if (Platform.isLinux) {
        ThanPkg.linux.app.launch(movie.path);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showInfo(MovieModel movie) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Info'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title: ${movie.title}'),
              Text('Ext: ${movie.ext}'),
              Text('Type: ${movie.type}'),
              Text('InfoType: ${movie.infoType}'),
              Text('Size: ${movie.size.toDouble().toFileSizeLabel()}'),
              Text('Tags: ${movie.tags}'),
              Text(
                  'Date: ${DateTime.fromMillisecondsSinceEpoch(movie.date).toParseTime()}'),
              Text('Path: ${movie.path}'),
            ],
          ),
        ),
      ),
    );
  }

  void _showMenu(MovieModel movie) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 200),
          child: Column(
            children: [
              //Open Another
              ListTile(
                leading: Icon(Icons.launch_rounded),
                title: Text('Open Another'),
                onTap: () {
                  Navigator.pop(context);
                  _openAnother();
                },
              ),
              //Info
              ListTile(
                leading: Icon(Icons.info_outlined),
                title: Text('Info'),
                onTap: () {
                  Navigator.pop(context);
                  _showInfo(movie);
                },
              ),
              //set tags
              TagListTileButton(
                values: movie.tags,
                onChoosed: (values) {},
              ),
              //Edit
              ListTile(
                leading: Icon(Icons.edit_document),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _goEdit();
                },
              ),
              //Restore
              movie.infoType == MovieInfoTypes.data.name
                  ? ListTile(
                      iconColor: Colors.amber,
                      leading: Icon(Icons.restore),
                      title: Text('Restore'),
                      onTap: () {
                        Navigator.pop(context);
                        _restore();
                      },
                    )
                  : SizedBox.shrink(),
              //delete
              ListTile(
                iconColor: Colors.red,
                leading: Icon(Icons.delete_forever),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteConfirm();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => _showMenu(context.read<MovieProvider>().getCurrent!),
        icon: Icon(Icons.more_vert));
  }
}
