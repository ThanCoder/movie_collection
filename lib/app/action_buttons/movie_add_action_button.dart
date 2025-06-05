import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:movie_collections/app/dialogs/index.dart';
import 'package:movie_collections/app/dialogs/series_form_dialog.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/lib_components/path_chooser.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/screens/movie_list_table_screen.dart';
import 'package:provider/provider.dart';

class MovieAddActionButton extends StatefulWidget {
  const MovieAddActionButton({super.key});

  @override
  State<MovieAddActionButton> createState() => _MovieAddActionButtonState();
}

class _MovieAddActionButtonState extends State<MovieAddActionButton> {
  void _pathSelector() async {
    try {
      final pathList = await platformVideoPathChooser(context);
      if (pathList.isEmpty) return;

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
      builder: (ctx) => RenameDialog(
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
            if (!ctx.mounted) return;
            showDialog(
              context: ctx,
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

  void _newSeries() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SeriesFormDialog(),
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
              // add series
              ListTile(
                leading: Icon(Icons.add),
                title: Text('New Series'),
                onTap: () {
                  Navigator.pop(context);
                  _newSeries();
                },
              ),
              //add from path
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Movie From Path'),
                onTap: () {
                  Navigator.pop(context);
                  _fromPath();
                },
              ),
              //add from path selector
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Movie Path Selector'),
                onTap: () {
                  Navigator.pop(context);
                  _pathSelector();
                },
              ),
              //movie table
              ListTile(
                leading: Icon(Icons.table_rows_rounded),
                title: Text('Movie Table List'),
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
