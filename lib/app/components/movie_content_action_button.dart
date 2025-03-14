import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/dialogs/core/index.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/screens/index.dart';
import 'package:provider/provider.dart';

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
      showMessage(context, 'မလုပ်ရသေးပါ');
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

  void _showMenu() {
    final movie = context.read<MovieProvider>().getCurrent!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 200),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.edit_document),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _goEdit();
                },
              ),
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
    return IconButton(onPressed: _showMenu, icon: Icon(Icons.more_vert));
  }
}
