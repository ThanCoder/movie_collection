import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/services/movie_services.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

class MovieFormHomePage extends StatefulWidget {
  const MovieFormHomePage({super.key});

  @override
  State<MovieFormHomePage> createState() => _MovieFormHomePageState();
}

class _MovieFormHomePageState extends State<MovieFormHomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController runningTimeController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void init() {
    if (currentMovieNotifier.value == null) return;
    titleController.text = currentMovieNotifier.value!.title;
    descController.text = currentMovieNotifier.value!.description;
    runningTimeController.text =
        currentMovieNotifier.value!.durationInMinutes.toString();
  }

  void _save() async {
    try {
      context.read<MovieProvider>().update(movie: currentMovieNotifier.value!);
      _showMsg2('Movie Updated');
      _goback();
    } catch (e) {
      _showMsg(e.toString());
    }
  }

  void _goback() {
    Navigator.pop(context);
  }

  void _showMsg(String msg) {
    showDialogMessage(context, msg);
  }

  void _showMsg2(String msg) {
    showMessage(context, msg);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentMovieNotifier,
      builder: (context, movie, child) {
        if (movie == null) {
          return Center(child: Text('current movie is null'));
        }
        return MyScaffold(
          appBar: AppBar(
            title: Text(movie.title),
            actions: [
              IconButton(
                onPressed: _save,
                icon: const Icon(Icons.save),
              ),
              MovieDeleteActionComponents(
                onDeleted: _goback,
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                //cover
                CoverComponents(
                  coverPath: getMovieCoverSourcePath(movieId: movie.id),
                ),
                TTextField(
                  label: Text('Title'),
                  controller: titleController,
                  onChanged: (value) {
                    currentMovieNotifier.value!.title = value;
                  },
                ),
                //movie type
                Row(
                  children: [
                    Text('Multiple Movie'),
                    Switch(
                      value: movie.isMultipleMovie,
                      onChanged: (value) {
                        final currentMovie = currentMovieNotifier.value!;
                        currentMovieNotifier.value = null;
                        currentMovie.isMultipleMovie = value;
                        currentMovieNotifier.value = currentMovie;
                      },
                    ),
                  ],
                ),
                //year
                YearComponent(
                  year: movie.year,
                  onChanged: (year) {
                    currentMovieNotifier.value!.year = year;
                  },
                ),
                //imdb
                ImdbComponent(
                  value: movie.imdb == 0 ? 1.0 : movie.imdb,
                  onChanged: (imdb) {
                    final currentMovie = currentMovieNotifier.value!;
                    currentMovieNotifier.value = null;
                    currentMovie.imdb = imdb;
                    currentMovieNotifier.value = currentMovie;
                  },
                ),
                //running time
                TTextField(
                  label: Text('Running Time Minutes'),
                  controller: runningTimeController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isEmpty || int.tryParse(value) == null) return;
                    currentMovieNotifier.value!.durationInMinutes =
                        int.parse(value);
                  },
                ),
                //genres
                GenresComponent(
                  genres: movie.genres,
                  onChange: (genres) {
                    currentMovieNotifier.value!.genres = genres;
                  },
                ),
                const Divider(),
                //desc
                TTextField(
                  label: Text('Description'),
                  maxLines: 7,
                  controller: descController,
                  onChanged: (value) {
                    currentMovieNotifier.value!.description = value;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
