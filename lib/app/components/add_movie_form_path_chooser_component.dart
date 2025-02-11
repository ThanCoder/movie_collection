import 'package:flutter/material.dart';
import 'package:movie_collections/app/dialogs/genres_form_dialog.dart';
import 'package:movie_collections/app/providers/genres_provider.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class AddMovieFormPathChooserComponent extends StatefulWidget {
  const AddMovieFormPathChooserComponent({super.key});

  @override
  State<AddMovieFormPathChooserComponent> createState() =>
      _AddMovieFormPathChooserComponentState();
}

class _AddMovieFormPathChooserComponentState
    extends State<AddMovieFormPathChooserComponent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GenresProvider>().initList();
    });
  }

  void _addGenres() {
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
          context.read<MovieProvider>().addMultipleMovieFromPath(
                genres.join(','),
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        // _addGenres();
        context.read<MovieProvider>().addMultipleMovieFromPath('');
      },
      leading: const Icon(Icons.add_circle),
      title: Text('Add Movie From Path'),
    );
  }
}
