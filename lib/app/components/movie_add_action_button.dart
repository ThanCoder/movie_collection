import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:movie_collections/app/dialogs/index.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MovieAddActionButton extends StatefulWidget {
  const MovieAddActionButton({super.key});

  @override
  State<MovieAddActionButton> createState() => _MovieAddActionButtonState();
}

class _MovieAddActionButtonState extends State<MovieAddActionButton> {
  void _pathSelector() async {
    try {
      final files = await openFiles(
        acceptedTypeGroups: [
          XTypeGroup(extensions: ['.mp4', '.mkv'], mimeTypes: ['video/mp4']),
        ],
      );

      if (files.isEmpty) return;

      List<String> pathList = files.map((f) => f.path).toList();

      ///choose type
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MovieTypeChooserDialog(
          onSubmited: (MovieTypes movieType, MovieInfoTypes movieInfoType) {
            if (!mounted) return;
            context.read<MovieProvider>().addFromPathList(
                  pathList: pathList,
                  movieInfoType: movieInfoType,
                  movieType: movieType,
                );
          },
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _newMovie() {
    showDialog(
      context: context,
      builder: (context) => RenameDialog(
        renameExistsTextList: context
            .read<MovieProvider>()
            .getList
            .map((mv) => mv.title)
            .toList(),
        onCancel: () {},
        onSubmit: (title) {
          if (title.isEmpty) return;
          final movie = MovieModel(
            id: Uuid().v4(),
            title: title,
            date: DateTime.now().millisecondsSinceEpoch,
            type: MovieTypes.movie.name,
            infoType: MovieInfoTypes.info.name,
          );
          context.read<MovieProvider>().add(movie: movie);
        },
      ),
    );
  }

  void _fromPath() {
    showDialog(
      context: context,
      builder: (context) => RenameDialog(
        title: 'Path ထည့်ပေးပါ',
        renameText: '',
        onCancel: () {},
        onSubmit: (path) async {
          try {
            if (path.isEmpty) return;
            final dir = Directory(path);
            if (!await dir.exists()) return;
            List<String> pathList = [];
            await for (var file in dir.list(recursive: true)) {
              // file မဟုတ်ရင်
              if (file.statSync().type != FileSystemEntityType.file) continue;
              final mime = lookupMimeType(file.path) ?? '';
              //video မဟုတ်ရင်
              if (!mime.startsWith('video')) continue;
              //is video
              pathList.add(file.path);
            }

            ///choose type
            if (!mounted) return;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => MovieTypeChooserDialog(
                onSubmited:
                    (MovieTypes movieType, MovieInfoTypes movieInfoType) {
                  if (!mounted) return;
                  context.read<MovieProvider>().addFromPathList(
                        pathList: pathList,
                        movieInfoType: movieInfoType,
                        movieType: movieType,
                      );
                },
              ),
            );
          } catch (e) {
            debugPrint(e.toString());
          }
        },
      ),
    );
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(minHeight: 200),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.add),
                title: Text('New Movie'),
                onTap: () {
                  Navigator.pop(context);
                  _newMovie();
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add From Path'),
                onTap: () {
                  Navigator.pop(context);
                  _fromPath();
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add From Path Selector'),
                onTap: () {
                  Navigator.pop(context);
                  _pathSelector();
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
      onPressed: _showMenu,
      icon: Icon(Icons.more_vert_rounded),
    );
  }
}
