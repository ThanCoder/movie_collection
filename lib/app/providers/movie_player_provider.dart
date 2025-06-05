import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/movie_model.dart';

class MoviePlayerProvider with ChangeNotifier {
  final List<MovieModel> _list = [];
  MovieModel? _movie;
  bool isLoading = false;

  List<MovieModel> get getList => _list;
  MovieModel? get getCurrent => _movie;
}
