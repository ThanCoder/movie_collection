import 'package:flutter/material.dart';
import 'package:movie_collections/app/dialogs/confirm_dialog.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/screens/movie_form_screen.dart';
import 'package:provider/provider.dart';

class MovieContentMenuActionComponent extends StatefulWidget {
  void Function()? onDeleted;
  MovieContentMenuActionComponent({
    super.key,
    this.onDeleted,
  });

  @override
  State<MovieContentMenuActionComponent> createState() =>
      _MovieContentMenuActionComponentState();
}

class _MovieContentMenuActionComponentState
    extends State<MovieContentMenuActionComponent> {
  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieFormScreen(),
                ),
              );
            },
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
          ),
          ListTile(
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
            },
            leading: const Icon(Icons.delete_forever),
            title: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteAll() async {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        contentText: 'သင်က ဖျက်ချင်တာ သေချာပြီလား',
        onCancel: () {},
        onSubmit: () async {
          try {
            context
                .read<MovieProvider>()
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
      onPressed: _showMenu,
      icon: const Icon(Icons.more_vert),
    );
  }
}
