import 'package:flutter/material.dart';
import 'package:movie_collections/app/dialogs/genres_form_dialog.dart';
import 'package:movie_collections/app/dialogs/rename_dialog.dart';
import 'package:movie_collections/app/providers/genres_provider.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class AddMovieFromPathBtnComponent extends StatefulWidget {
  const AddMovieFromPathBtnComponent({super.key});

  @override
  State<AddMovieFromPathBtnComponent> createState() =>
      _AddMovieFromPathBtnComponentState();
}

class _AddMovieFromPathBtnComponentState
    extends State<AddMovieFromPathBtnComponent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GenresProvider>().initList();
    });
  }

  void _addGenres(String dirPath, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => GenresFormDialog(
        genresList: context.read<GenresProvider>().getList,
        onAddGenres: (genres) {
          context.read<GenresProvider>().add(genres: genres);
        },
        onDeleteGenres: (genres) {
          context.read<GenresProvider>().delete(genres: genres);
        },
        onCancel: () {},
        onSubmit: (genres) {
          context
              .read<MovieProvider>()
              .addMultipleMovieFromDirPath(genres.join(','), dirPath);
        },
      ),
    );
  }

  void _getDirPath() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RenameDialog(
        renameLabelText: Text('Dir Path ထည့်ပေးပါ'),
        renameText: '',
        onCancel: () {},
        onSubmit: (path) {
          _addGenres(path, context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        _getDirPath();
      },
      leading: const Icon(Icons.add_circle),
      title: Text('Add Movie From Dir Path'),
    );
  }
}
