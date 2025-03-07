import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/utils/index.dart';

class MovieServices {
  static final MovieServices instance = MovieServices._();
  MovieServices._();
  factory MovieServices() => instance;

  Future<MovieModel> getMovieFullInfo(MovieModel movie) async {
    final source = '${PathUtil.instance.getDatabaseSourcePath()}/${movie.id}';
    final contentFile = File('${PathUtil.instance.createDir(source)}/content');
    if (await contentFile.exists()) {
      movie.content = await contentFile.readAsString();
    }
    return movie;
  }

  Future<void> setMovieFullInfo(MovieModel movie) async {
    final source = '${PathUtil.instance.getDatabaseSourcePath()}/${movie.id}';
    final contentFile = File('${PathUtil.instance.createDir(source)}/content');
    await contentFile.writeAsString(movie.content);
  }

  Future<void> deleteMovieFullInfo(MovieModel movie) async {
    final source = '${PathUtil.instance.getDatabaseSourcePath()}/${movie.id}';
    final dir = Directory(source);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  Future<int> getPosition({required MovieModel movie}) async {
    int res = 0;
    try {
      final source = '${PathUtil.instance.getDatabaseSourcePath()}/${movie.id}';
      final dbFile =
          File('${PathUtil.instance.createDir(source)}/position.txt');
      //map json
      if (await dbFile.exists()) {
        final text = await dbFile.readAsString();
        if (text.isNotEmpty && int.tryParse(text) != null) {
          res = int.parse(text);
        }
      }
    } catch (e) {
      debugPrint('getPosition: ${e.toString()}');
    }
    return res;
  }

  Future<void> setPosition(
      {required MovieModel movie, required int duration}) async {
    try {
      final source = '${PathUtil.instance.getDatabaseSourcePath()}/${movie.id}';
      final dbFile =
          File('${PathUtil.instance.createDir(source)}/position.txt');
      await dbFile.writeAsString('$duration');
    } catch (e) {
      debugPrint('setPosition: ${e.toString()}');
    }
  }
}
