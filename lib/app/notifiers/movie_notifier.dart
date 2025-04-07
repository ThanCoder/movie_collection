import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/index.dart';

ValueNotifier<MovieModel?> currentMovieNotifier = ValueNotifier(null);

ValueNotifier<bool> isHomePageDropableNotifier = ValueNotifier(true);
