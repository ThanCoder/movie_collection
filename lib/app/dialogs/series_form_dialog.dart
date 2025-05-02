import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/tag_list_chooser.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/extensions/index.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/screens/movie_series_form_screen.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

class SeriesFormDialog extends StatefulWidget {
  const SeriesFormDialog({super.key});

  @override
  State<SeriesFormDialog> createState() => _SeriesFormDialogState();
}

class _SeriesFormDialogState extends State<SeriesFormDialog> {
  final TextEditingController titleController = TextEditingController();
  String tags = '';
  String type = MovieTypes.series.name;
  String? errorText;

  @override
  void initState() {
    titleController.text = 'Untitled';
    super.initState();
    _checkError();
  }

  void _checkError() {
    final res = MovieModel.db.values
        .where((mv) => mv.title == titleController.text);
    if (res.isNotEmpty) {
      setState(() {
        errorText = 'title ရှိနေပြီးသား ဖြစ်နေပါတယ်!';
      });
    } else {
      setState(() {
        errorText = null;
      });
    }
  }

  void _add() async {
    final movie = MovieModel.create(
      title: titleController.text,
      path: '',
      type: type,
      infoType: MovieInfoTypes.info.name,
      size: 0,
    );
    
    await context.read<MovieProvider>().add(movie: movie);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieSeriesFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Series'),
      content: SingleChildScrollView(
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            TTextField(
              label: Text('Title...'),
              controller: titleController,
              isSelectedAll: true,
              errorText: errorText,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    errorText = 'is empty!';
                  });
                  return;
                }
                final list =
                    MovieModel.db.values.where((mv) => mv.title == value);
                if (list.isNotEmpty) {
                  setState(() {
                    errorText = 'title ရှိနေပြီးသား ဖြစ်နေပါတယ်!';
                  });
                  return;
                }
                setState(() {
                  errorText = null;
                });
              },
            ),
            // type
            Text('Type: ${type.toCaptalize()}'),
            // tags
            Text('Tags'),
            TagListChooser(
              tags: tags,
              onChanged: (value) {
                setState(() {
                  tags = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: errorText != null
              ? null
              : () {
                  Navigator.pop(context);
                  _add();
                },
          child: Text('Add'),
        ),
      ],
    );
  }
}
