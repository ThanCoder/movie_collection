import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/episode_model.dart';

class SeriesVideoPlayerProvider with ChangeNotifier {
  List<EpisodeModel> list = [];
  int currentIndex = 0;
  String movieId = '';
  EpisodeModel? currentEpisode;

  void setList(List<EpisodeModel> list) {
    this.list = list;
    currentIndex = 0;
    if (list.isNotEmpty) {
      currentEpisode = list[currentIndex];
    }
    notifyListeners();
  }

  void setMovidId(String movieId) {
    this.movieId = movieId;
    // notifyListeners();
  }

  void setCurrentIndex(int index) {
    if (currentIndex == index) return;
    currentIndex = index;
    if (list.isNotEmpty) {
      currentEpisode = list[index];
    }
    notifyListeners();
  }

  void setCurrentEpisode(EpisodeModel episode) {
    if (currentEpisode != null &&
        currentEpisode!.episodeNumber == episode.episodeNumber) {
      return;
    }
    currentEpisode = episode;
    notifyListeners();
  }
}
