import 'package:flutter/material.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/pages/series_movie_content_page.dart';
import 'package:movie_collections/app/pages/single_movie_content_page.dart';

class MovieContentScreen extends StatelessWidget {
  const MovieContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentMovieNotifier,
      builder: (context, movie, child) {
        if (movie == null) {
          return const Placeholder();
        }
        if (movie.isMultipleMovie) {
          return SeriesMovieContentPage();
        } else {
          return SingleMovieContentPage();
        }
      },
    );
  }
}
