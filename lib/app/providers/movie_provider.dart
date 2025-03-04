import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/models/movie_model.dart';

class MovieProvider with ChangeNotifier {
  List<MovieModel> _list = [];
  bool _isLoading = false;

  List<MovieModel> get getList => _list;
  bool get isLoading => _isLoading;

  late Box<MovieModel> _box;

  MovieProvider() {
    _box = Hive.box<MovieModel>(MovieModel.getName);
  }

  Future<void> initList() async {
    try {
      _isLoading = true;
      notifyListeners();

      print(_box.values);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('initList: ${e.toString()}');
    }
  }

  Future<void> add({required MovieModel movie}) async {
    try {
      _isLoading = true;
      notifyListeners();

      _list.insert(0, movie);
      _box.add(movie);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('add: ${e.toString()}');
    }
  }

  Future<void> addFromPathList({
    required List<String> pathList,
    required MovieTypes movieType,
    required MovieInfoTypes movieInfoType,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      print(pathList);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('add: ${e.toString()}');
    }
  }
}
