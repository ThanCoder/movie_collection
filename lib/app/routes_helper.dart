import 'package:flutter/material.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/screens/result_screen.dart';

import 'models/movie_model.dart';

void goResultScreen(
  BuildContext context, {
  required String title,
  required List<MovieModel> list,
}) {
  resultScreenDataNotifier.value = resultScreenDataNotifier.value.copyWith(
    title: title,
    list: list,
  );
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ResultScreen(),
    ),
  );
}
