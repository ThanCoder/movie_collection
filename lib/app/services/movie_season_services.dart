import 'dart:convert';
import 'dart:io';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/models/episode_model.dart';
import 'package:movie_collections/app/models/season_model.dart';
import 'package:movie_collections/app/utils/path_util.dart';

class MovieSeasonServices {
  static final MovieSeasonServices instance = MovieSeasonServices._();
  MovieSeasonServices._();
  factory MovieSeasonServices() => instance;

  Future<List<SeasonModel>> getList(String movieId) async {
    List<SeasonModel> list = [];

    final dbFile = File(getDBPath(movieId));
    if (await dbFile.exists()) {
      List<dynamic> res = jsonDecode(await dbFile.readAsString());
      list = res.map((map) => SeasonModel.fromMap(map)).toList();
    }

    return list;
  }

  Future<void> setList(
    String movieId, {
    required List<SeasonModel> list,
  }) async {
    final dbFile = File(getDBPath(movieId));
    //map json
    final data = jsonEncode(list.map((ms) => ms.toMap()).toList());
    await dbFile.writeAsString(data);
  }

  static String getVideoPath(EpisodeModel episode) {
    if (episode.infoType == MovieInfoTypes.data.name) {
      return '${PathUtil.instance.getDatabaseSourcePath()}/${episode.movieId}/${episode.id}';
    }
    return episode.path;
  }

  static String getDBPath(String movieId) =>
      '${PathUtil.instance.getDatabaseSourcePath()}/$movieId/season.db.json';
}
