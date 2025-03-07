import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

class MovieFormHomePage extends StatefulWidget {
  const MovieFormHomePage({super.key});

  @override
  State<MovieFormHomePage> createState() => _MovieFormHomePageState();
}

class _MovieFormHomePageState extends State<MovieFormHomePage> {
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

  void _chooseVideoFile(MovieModel movie) async {
    context.read<MovieProvider>().addVideoFromPathWithInfoType(context);
  }

  void _deleteMovieFile(MovieModel movie) {
    context.read<MovieProvider>().deleteMovieFile(context, movie);
  }

  Widget _getVideoChooser(MovieModel movie) {
    if (movie.infoType == MovieInfoTypes.data.name) {
      //check movie file ရှိလားစစ်မယ်
      if (File(movie.getSourcePath()).existsSync()) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text('Video File (Move ထည့်မယ်)'),
            MovieListItem(
              movie: movie,
              onClicked: (movie, itemHeight) {
                _chooseVideoFile(movie);
              },
              onLongClicked: _deleteMovieFile,
            ),
          ],
        );
      }
      //မရှိဘူးဆိုရင်
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Text('Video File (Move ထည့်မယ်)'),
          IconButton(
              onPressed: () => _chooseVideoFile(movie),
              icon: Icon(Icons.move_down_rounded)),
        ],
      );
    }
    //info type
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Text('Original Path:'),
          Text(movie.path),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final isLoading = provider.isLoading;
    final movie = provider.getCurrent!;
    return MyScaffold(
      appBar: AppBar(
        title: Text(
          'Form ${movie.title}',
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 10,
                      children: [
                        Text('Movie Type'),
                        MovieTypeChooser(
                          type: MovieTypesExtension.getType(movie.type),
                          onChoosed: (type) {
                            movie.type = type.name;
                            context.read<MovieProvider>().setCurrent(movie);
                          },
                        ),
                        Text('Info Type'),
                        MovieInfoTypeChooser(
                          type: MovieInfoTypesExtension.getType(movie.infoType),
                          onChoosed: (type) {
                            movie.infoType = type.name;
                            context.read<MovieProvider>().setCurrent(movie);
                          },
                        ),
                      ],
                    ),
                  ),
                  //show video
                  _getVideoChooser(movie),
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
