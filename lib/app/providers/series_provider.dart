import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_collections/app/enums/movie_info_types.dart';
import 'package:movie_collections/app/models/episode_model.dart';
import 'package:movie_collections/app/models/season_model.dart';
import 'package:movie_collections/app/services/movie_season_services.dart';
import 'package:movie_collections/app/utils/index.dart';

class SeriesProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //movie season list
  List<SeasonModel> seasonList = [];
  void intSeasonList(String movieId) async {
    _isLoading = true;
    notifyListeners();

    seasonList = await MovieSeasonServices.instance.getList(movieId);
    // sort
    seasonList.sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));

    _isLoading = false;
    notifyListeners();
  }

  void addSeason(
      {required String movieId,
      required int seasonNumber,
      String title = 'Untitled'}) async {
    _isLoading = true;
    notifyListeners();

    final season = SeasonModel.create(
      movieId: movieId,
      title: title,
      seasonNumber: seasonNumber,
    );

    seasonList.add(season);

    await MovieSeasonServices.instance.setList(movieId, list: seasonList);
    intSeasonList(movieId);
  }

  void deleteSeason({required SeasonModel season}) async {
    _isLoading = true;
    notifyListeners();

    //delete episode file
    for (var ep in season.episodes) {
      final videoFile = File(ep.getVideoPath());
      if (await videoFile.exists()) {
        await videoFile.delete();
      }
    }
    //remove season
    seasonList = seasonList.where((se) => se.id != season.id).toList();

    // _isLoading = false;
    // notifyListeners();

    await MovieSeasonServices.instance
        .setList(season.movieId, list: seasonList);
    intSeasonList(season.movieId);
  }

  void setSeasonList(
      {required String movieId,
      required int seasonNumber,
      required List<SeasonModel> list}) async {
    _isLoading = true;
    notifyListeners();

    await MovieSeasonServices.instance.setList(movieId, list: list);
    intSeasonList(movieId);
  }

  //episode
  void addEpisodesPathList({
    required SeasonModel season,
    required String infoType,
    required List<String> pathList,
  }) async {
    try {
      final seasonIndex = seasonList.indexWhere((se) => se.id == season.id);
      _isLoading = true;
      notifyListeners();
      int epLatestNumber =
          season.episodes.isEmpty ? 0 : season.episodes.last.episodeNumber;
      for (var path in pathList) {
        final ep = EpisodeModel.createFilePath(
          path,
          seasonId: season.id,
          movieId: season.movieId,
          episodeNumber: epLatestNumber + 1,
          infoType: infoType,
        );
        //add
        if (ep.infoType == MovieInfoTypes.data.name) {
          //real data file
          final file = File(ep.path);
          if (await file.exists()) {
            //copy
            final newPath = ep.getVideoPath();
            await file.rename(newPath);
          }
        }

        season.episodes.add(ep);
        epLatestNumber++;
      }

      //set resset ui
      seasonList[seasonIndex] = season;

      await MovieSeasonServices.instance
          .setList(season.movieId, list: seasonList);
      intSeasonList(season.movieId);
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void deleteEpisode(SeasonModel season, EpisodeModel episode) async {
    try {
      if (episode.infoType == MovieInfoTypes.data.name) {
        final videoFile = File(episode.getVideoPath());
        if (await videoFile.exists()) {
          await videoFile.delete();
        }
      }

      final index = seasonList.indexWhere((se) => se.id == season.id);
      final epList =
          season.episodes.where((ep) => ep.id != episode.id).toList();
      //sort
      epList.sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));

      seasonList[index].episodes = epList;

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void restoreEpisode(SeasonModel season, EpisodeModel episode) async {
    try {
      //
      if (episode.infoType == MovieInfoTypes.data.name) {
        final videoFile = File(episode.getVideoPath());
        if (await videoFile.exists()) {
          final newPath =
              '${PathUtil.instance.getOutPath()}/${episode.title}.${episode.ext}';
          await videoFile.rename(newPath);
        }
      }

      final index = seasonList.indexWhere((se) => se.id == season.id);
      final epList =
          season.episodes.where((ep) => ep.id != episode.id).toList();
      seasonList[index].episodes = epList;

      //sort
      epList.sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));

      await MovieSeasonServices.instance
          .setList(season.movieId, list: seasonList);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateEpisode(SeasonModel season, EpisodeModel episode) async {
    try {
      final index = seasonList.indexWhere((se) => se.id == season.id);
      final epList = season.episodes.map((ep) {
        if (ep.id == episode.id) {
          return episode;
        }
        return ep;
      }).toList();

      //sort
      epList.sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));

      seasonList[index].episodes = epList;

      await MovieSeasonServices.instance
          .setList(season.movieId, list: seasonList);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }
}
