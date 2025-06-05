import 'package:flutter/material.dart';
import 'package:movie_collections/app/dialogs/index.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

class MovieDeleteActionButton extends StatefulWidget {
  VoidCallback onDone;
  MovieDeleteActionButton({
    super.key,
    required this.onDone,
  });

  @override
  State<MovieDeleteActionButton> createState() =>
      _MovieDeleteActionButtonState();
}

class _MovieDeleteActionButtonState extends State<MovieDeleteActionButton> {
  void _confirm(MovieModel movie) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmDialog(
        contentText: '`${movie.title}` ကိုဖျက်ချင်တာ သေချာပြီလား',
        submitText: 'Delete',
        onCancel: () {},
        onSubmit: () async {
          await context.read<MovieProvider>().delete(movie);
          widget.onDone();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final isLoading = provider.isLoading;
    final movie = provider.getCurrent!;
    if (isLoading) {
      return TLoader();
    }
    return IconButton(
      color: Colors.red,
      onPressed: () => _confirm(movie),
      icon: Icon(Icons.delete_forever),
    );
  }
}
