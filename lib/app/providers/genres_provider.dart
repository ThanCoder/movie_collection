import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_collections/app/models/genres_model.dart';

class GenresProvider with ChangeNotifier {
  static final String boxName = 'genres';
  final List<GenresModel> _list = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<GenresModel> get getList => _list;

  Future<void> initList() async {
    try {
      _isLoading = true;
      notifyListeners();

      final list = Hive.box<GenresModel>(boxName).values.toList();
      //add provider
      _list.clear();
      _list.addAll(list);
      _isLoading = false;

      notifyListeners();
    } catch (e) {
      debugPrint('initList: ${e.toString()}');
    }
  }

  Future<void> add({required GenresModel genres}) async {
    try {
      final box = Hive.box<GenresModel>(boxName);
      box.add(genres);
      //update provider
      _list.add(genres);
      notifyListeners();
    } catch (e) {
      debugPrint('add: ${e.toString()}');
    }
  }

  Future<void> update({required GenresModel movie}) async {
    try {
      final box = Hive.box<GenresModel>(boxName);
      final index = box.values.toList().indexOf(movie);
      //update
      box.put(index, movie);
      //update provider
      _list[index] = movie;
      notifyListeners();
    } catch (e) {
      debugPrint('update: ${e.toString()}');
    }
  }

  Future<void> delete({required GenresModel genres}) async {
    try {
      final box = Hive.box<GenresModel>(boxName);
      final index = box.values.toList().indexOf(genres);
      //delete box
      box.deleteAt(index);
      //update provider
      _list.removeAt(index);
      notifyListeners();
    } catch (e) {
      debugPrint('delete: ${e.toString()}');
    }
  }
}
