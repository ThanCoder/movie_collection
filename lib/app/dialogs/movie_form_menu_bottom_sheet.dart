import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/core/app_components.dart';
import 'package:movie_collections/app/dialogs/core/confirm_dialog.dart';
import 'package:movie_collections/app/enums/movie_info_types.dart';
import 'package:movie_collections/app/enums/movie_types.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/screens/movie_form_screen.dart';
import 'package:provider/provider.dart';

class MovieFormMenuBottomSheet extends StatefulWidget {
  MovieModel movie;
  void Function(MovieModel movie)? onDeleted;
  void Function(MovieModel movie)? onRestored;
  void Function()? onEdit;

  MovieFormMenuBottomSheet({
    super.key,
    required this.movie,
    this.onDeleted,
    this.onRestored,
    this.onEdit,
  });

  @override
  State<MovieFormMenuBottomSheet> createState() =>
      _MovieFormMenuBottomSheetState();
}

class _MovieFormMenuBottomSheetState extends State<MovieFormMenuBottomSheet> {
  void _deleteConfirm() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmDialog(
        contentText: '`${widget.movie.title}` ကိုဖျက်ချင်တာ သေချာပြီလား',
        submitText: 'Delete',
        onCancel: () {},
        onSubmit: () async {
          await context.read<MovieProvider>().delete(widget.movie);
          if (widget.onDeleted != null) {
            widget.onDeleted!(widget.movie);
          }
        },
      ),
    );
  }

  void _goEdit() async {
    final movie = context.read<MovieProvider>().getCurrent!;
    if (movie.type == MovieTypes.series.name) {
      showMessage(context, 'မလုပ်ရသေးပါ');
      return;
    }
    if (widget.onEdit != null) {
      widget.onEdit!();
      return;
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieFormScreen(),
      ),
    );
  }

  void _restore() {
    context.read<MovieProvider>().restoreMovieFile(
      context,
      movie: widget.movie,
      onDoned: () {
        Navigator.pop(context);
        if (widget.onRestored != null) {
          widget.onRestored!(widget.movie);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            widget.movie.infoType == MovieInfoTypes.data.name
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
    );
  }
}
