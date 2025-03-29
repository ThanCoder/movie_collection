import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/movie_model.dart';

class MoviePlayerProvider with ChangeNotifier {
  final List<MovieModel> _list = [];
  MovieModel? _movie;
  bool _isLoading = false;

  List<MovieModel> get getList => _list;
  bool get isLoading => _isLoading;
  MovieModel? get getCurrent => _movie;
}
