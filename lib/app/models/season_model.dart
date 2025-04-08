import 'package:movie_collections/app/models/episode_model.dart';
import 'package:uuid/uuid.dart';

class SeasonModel {
  String id;
  String movieId;
  String title;
  int seasonNumber;
  String desc;
  int date;
  List<EpisodeModel> episodes = [];
  SeasonModel({
    required this.id,
    required this.movieId,
    required this.seasonNumber,
    required this.date,
    this.title = 'Untitled',
    this.desc = '',
    this.episodes = const [],
  });

  factory SeasonModel.create({
    required String movieId,
    required String title,
    required int seasonNumber,
  }) {
    return SeasonModel(
      id: Uuid().v4(),
      movieId: movieId,
      title: title,
      seasonNumber: seasonNumber,
      date: DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory SeasonModel.fromMap(Map<String, dynamic> map) {
    List<dynamic> resList = map['episodes'] ?? [];
    final list = resList.map((map) => EpisodeModel.fromMap(map)).toList();
    return SeasonModel(
      id: map['id'],
      movieId: map['movieId'],
      title: map['title'],
      desc: map['desc'],
      seasonNumber: map['seasonNumber'],
      date: map['date'],
      episodes: list,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'movieId': movieId,
        'title': title,
        'seasonNumber': seasonNumber,
        'desc': desc,
        'date': date,
        'episodes': episodes.map((ep) => ep.toMap()).toList()
      };
}
