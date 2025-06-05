import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_collections/app/constants.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/utils/index.dart';

class BookmarkServices extends ChangeNotifier {
  static final BookmarkServices instance = BookmarkServices._();
  BookmarkServices._();
  factory BookmarkServices() => instance;

  Future<void> toggle({required String movieId}) async {
    try {
      if (await isExists(movieId: movieId)) {
        await remove(movieId: movieId);
      } else {
        await add(movieId: movieId);
      }
    } catch (e) {
      debugPrint('add: ${e.toString()}');
    }
  }

  Future<void> add({required String movieId}) async {
    try {
      final dbFile = File(getDBPath());
      final list = await getList();
      list.insert(0, movieId);
      //save
      await dbFile.writeAsString(jsonEncode(list));
      notifyListeners();
    } catch (e) {
      debugPrint('add: ${e.toString()}');
    }
  }

  Future<void> remove({required String movieId}) async {
    try {
      final dbFile = File(getDBPath());
      var list = await getList();
      list = list.where((id) => id != movieId).toList();
      //save
      await dbFile.writeAsString(jsonEncode(list));
      notifyListeners();
    } catch (e) {
      debugPrint('add: ${e.toString()}');
    }
  }

  Future<bool> isExists({required String movieId}) async {
    bool res = false;
    try {
      final list = await getList();
      res = list.any((id) => id == movieId);
    } catch (e) {
      debugPrint('isExists: ${e.toString()}');
    }
    return res;
  }

  Future<List<String>> getList() async {
    List<String> list = [];
    try {
      final dbFile = File(getDBPath());
      if (!await dbFile.exists()) return list;
      List<dynamic> res = jsonDecode(await dbFile.readAsString());
      list = List<String>.from(res);
    } catch (e) {
      debugPrint('getList: ${e.toString()}');
    }
    return list;
  }

  Future<List<MovieModel>> getMovieList() async {
    List<MovieModel> movieList = [];
    final idList = await getList();
    final list = MovieModel.db.values;

    for (var id in idList) {
      final movie = list.where((mv) => mv.id == id);
      if (movie.isNotEmpty) {
        movieList.add(movie.first);
      }
    }

    return movieList;
  }

  String getDBPath() {
    return '${PathUtil.instance.getDatabasePath()}/$appBookmarkDatabaseName';
  }
}
