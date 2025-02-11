import 'package:flutter/material.dart';
import 'package:movie_collections/app/dialogs/confirm_dialog.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class MovieDeleteActionComponents extends StatefulWidget {
  void Function()? onDeleted;
  MovieDeleteActionComponents({super.key, this.onDeleted});

  @override
  State<MovieDeleteActionComponents> createState() =>
      _MovieDeleteActionComponentsState();
}

class _MovieDeleteActionComponentsState
    extends State<MovieDeleteActionComponents> {
  void _deleteAll() async {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        contentText: 'သင်က ဖျက်ချင်တာ သေချာပြီလား',
        onCancel: () {},
        onSubmit: () async {
          try {
            Provider.of<MovieProvider>(context, listen: false)
                .delete(movie: currentMovieNotifier.value!);
            //is success
            if (widget.onDeleted != null) {
              widget.onDeleted!();
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.red,
      onPressed: _deleteAll,
      icon: const Icon(Icons.delete),
    );
  }
}
