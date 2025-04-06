import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:movie_collections/app/dialogs/index.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/screens/movie_list_table_screen.dart';
import 'package:movie_collections/app/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:real_path_file_selector/real_path_file_selector.dart';

class MovieAddActionButton extends StatefulWidget {
  const MovieAddActionButton({super.key});

  @override
  State<MovieAddActionButton> createState() => _MovieAddActionButtonState();
}

class _MovieAddActionButtonState extends State<MovieAddActionButton> {
  void _pathSelector() async {
    try {
      List<String> pathList = [];

      if (Platform.isLinux) {
        final files = await openFiles(
          acceptedTypeGroups: [
            XTypeGroup(extensions: ['.mp4', '.mkv'], mimeTypes: ['video/mp4']),
          ],
        );

        if (files.isEmpty) return;
        pathList = files.map((f) => f.path).toList();
      } else if (Platform.isAndroid) {
        pathList = await RealPathFileSelector.openFileScanner.open(
          context,
          mimeType: 'video',
          title: 'Choose Movie',
          thumbnailDirPath: PathUtil.instance.getCachePath(),
        );
      }

      ///choose type
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MovieTypeChooserDialog(
          onSubmited: (MovieTypes movieType, MovieInfoTypes movieInfoType,
              String tags) {
            if (!mounted) return;
            context.read<MovieProvider>().addFromPathList(
                  pathList: pathList,
                  movieInfoType: movieInfoType,
                  movieType: movieType,
                  tags: tags,
                );
          },
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
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
                onSubmited: (MovieTypes movieType, MovieInfoTypes movieInfoType,
                    String tags) {
                  if (!mounted) return;
                  context.read<MovieProvider>().addFromPathList(
                        pathList: pathList,
                        movieInfoType: movieInfoType,
                        movieType: movieType,
                        tags: tags,
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
              // ListTile(
              //   leading: Icon(Icons.add),
              //   title: Text('New Movie'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _newMovie();
              //   },
              // ),
              //add from path
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add From Path'),
                onTap: () {
                  Navigator.pop(context);
                  _fromPath();
                },
              ),
              //add from path selector
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add From Path Selector'),
                onTap: () {
                  Navigator.pop(context);
                  _pathSelector();
                },
              ),
              //movie table
              ListTile(
                leading: Icon(Icons.table_rows_rounded),
                title: Text('Movie List'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieListTableScreen(),
                    ),
                  );
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
