import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/extensions/index.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

class MovieSeriesFormHomePage extends StatefulWidget {
  const MovieSeriesFormHomePage({super.key});

  @override
  State<MovieSeriesFormHomePage> createState() =>
      _MovieSeriesFormHomePageState();
}

class _MovieSeriesFormHomePageState extends State<MovieSeriesFormHomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    final movie = context.read<MovieProvider>().getCurrent!;
    titleController.text = movie.title;
    descController.text = movie.content;
  }

  void _saveMovie() async {
    final movie = context.read<MovieProvider>().getCurrent!;
    movie.content = descController.text;
    movie.title = titleController.text;
    await context.read<MovieProvider>().update(movie);
    if (!mounted) return;
    Navigator.pop(context);
    showMessage(context, 'Saved Movie');
  }

  // void _chooseVideoFile(MovieModel movie) async {
  //   context.read<MovieProvider>().addVideoFromPathWithInfoType(context);
  // }

  // void _deleteMovieFile(MovieModel movie) {
  //   context.read<MovieProvider>().deleteMovieFile(context, movie);
  // }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final isLoading = provider.isLoading;
    final movie = provider.getCurrent!;
    return MyScaffold(
      appBar: AppBar(
        title: Text(
          'Series Form ${movie.title}',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _saveMovie(),
            icon: Icon(Icons.save_as_outlined),
          ),
        ],
      ),
      body: isLoading
          ? TLoader()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Column(
                        spacing: 10,
                        children: [
                          //cover
                          Text(
                            'Cover',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CoverComponents(
                            coverPath: movie.coverPath,
                          ),
                        ],
                      ),
                    ],
                  ),
                  //field
                  TTextField(
                    label: Text('Title'),
                    controller: titleController,
                    isSelectedAll: true,
                  ),
                  //type
                  Text('Type: `${movie.type.toCaptalize()}`'),
                  //desc
                  TTextField(
                    label: Text('Description'),
                    controller: descController,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
    );
  }
}
