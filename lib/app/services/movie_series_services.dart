import 'dart:convert';
import 'dart:io';

import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/utils/index.dart';

class MovieSeriesServices {
  static final MovieSeriesServices instance = MovieSeriesServices._();
  MovieSeriesServices._();
  factory MovieSeriesServices() => instance;

  Future<List<SeriesModel>> getList(MovieModel movie) async {
    List<SeriesModel> list = [];
    final source = '${PathUtil.instance.getDatabaseSourcePath()}/${movie.id}';
    final dbFile =
        File('${PathUtil.instance.createDir(source)}/series.db.json');
    if (await dbFile.exists()) {
      List<dynamic> res = jsonDecode(await dbFile.readAsString());
      list = res.map((map) => SeriesModel.fromMap(map)).toList();
    }

    return list;
  }

  Future<void> setList({
    required MovieModel movie,
    required List<SeriesModel> list,
  }) async {
    final source = '${PathUtil.instance.getDatabaseSourcePath()}/${movie.id}';
    final dbFile =
        File('${PathUtil.instance.createDir(source)}/series.db.json');
    //map json
    final data = jsonEncode(list.map((ms) => ms.toMap()).toList());
    await dbFile.writeAsString(data);
  }
}
