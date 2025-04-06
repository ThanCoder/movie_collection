import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_collections/app/constants.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/models/tag_model.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/utils/path_util.dart';

class TagServices {
  static final TagServices instance = TagServices._();
  TagServices._();
  factory TagServices() => instance;

  List<MovieModel> getMovieList(String tagName) {
    List<MovieModel> movieList = [];
    for (var movie in MovieProvider.getDB.values.toList()) {
      final tags = movie.tags.split(',').toSet();
      if (tags.contains(tagName)) {
        movieList.add(movie);
      }
    }

    return movieList;
  }

  Future<void> add(TagModel tag) async {
    final list = await getList();
    list.insert(0, tag);
    //to map
    final mapList = list.map((tg) => tg.toMap()).toList();
    final dbFile = File(getDBPath);
    await dbFile.writeAsString(jsonEncode(mapList));
  }

  Future<void> remove(TagModel tag) async {
    var list = await getList();
    list = list.where((tg) => tg.name != tag.name).toList();
    //to map
    final mapList = list.map((tg) => tg.toMap()).toList();
    final dbFile = File(getDBPath);
    await dbFile.writeAsString(jsonEncode(mapList));
  }

  Future<List<TagModel>> getList() async {
    List<TagModel> list = [];
    try {
      final dbFile = File(getDBPath);
      if (!await dbFile.exists()) return list;
      List<dynamic> res = jsonDecode(await dbFile.readAsString());
      list = res.map((map) => TagModel.fromMap(map)).toList();
    } catch (e) {
      debugPrint('getList: ${e.toString()}');
    }
    return list;
  }

  String get getDBPath =>
      '${PathUtil.instance.getDatabasePath()}/$appTagsDatabaseName';
}
