import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/episode_model.dart';

class SeriesVideoPlayerProvider with ChangeNotifier {
  List<EpisodeModel> list = [];
  int currentIndex = 0;
  String movieId = '';

  void setList(List<EpisodeModel> list) {
    this.list = list;
    currentIndex = 0;
    notifyListeners();
  }

  void setMovidId(String movieId) {
    this.movieId = movieId;
    notifyListeners();
  }

  void setCurrentIndex(int currentIndex) {
    this.currentIndex = currentIndex;
    notifyListeners();
  }
}
