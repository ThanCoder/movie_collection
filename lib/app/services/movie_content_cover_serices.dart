import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_collections/app/utils/path_util.dart';
import 'package:uuid/uuid.dart';

class MovieContentCoverSerices {
  static final MovieContentCoverSerices instance = MovieContentCoverSerices._();
  MovieContentCoverSerices._();
  factory MovieContentCoverSerices() => instance;

  Future<void> remove({required String movieId, required int index}) async {
    final dbList = await getList(movieId);
    //file
    final imageFile = File('${getDBPath(movieId)}/${dbList[index]}');
    if (await imageFile.exists()) {
      await imageFile.delete();
    }

    final removedList = dbList.where((id) => id != dbList[index]).toList();
    final dbFile = File(getDBPath(movieId));
    await dbFile.writeAsString(jsonEncode(removedList));
  }

  Future<void> add({
    required String movieId,
    required List<String> pathList,
  }) async {
    final dbList = await getList(movieId);
    //copy image
    for (var path in pathList) {
      final imageFile = File(path);
      if (!await imageFile.exists()) continue;
      final imageId = Uuid().v4();
      final savePath = getImagePath(
        movieId,
        imageId,
      );
      await imageFile.copy(savePath);
      dbList.add(imageId);
    }
    final dbFile = File(getDBPath(movieId));
    await dbFile.writeAsString(jsonEncode(dbList));
  }

  Future<List<String>> getList(String movieId) async {
    // await Future.delayed(Duration(seconds: 2));

    List<String> list = [];
    try {
      final dbFile = File(getDBPath(movieId));
      if (!await dbFile.exists()) return list;
      List<dynamic> res = jsonDecode(await dbFile.readAsString());
      list = List<String>.from(res);
    } catch (e) {
      debugPrint('getList: ${e.toString()}');
    }
    return list;
  }

  static String getImagePath(String movieId, String imageId) {
    return '${PathUtil.instance.getDatabaseSourcePath()}/$movieId/$imageId.png';
  }

  static String getDBPath(String movieId) =>
      '${PathUtil.instance.getDatabaseSourcePath()}/$movieId/content-list.json';
}
