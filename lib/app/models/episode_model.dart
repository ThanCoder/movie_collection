import 'dart:io';
import 'package:movie_collections/app/extensions/index.dart';
import 'package:uuid/uuid.dart';

class EpisodeModel {
  String id;
  String seasonId;
  String title;
  int episodeNumber;
  String path;
  String ext;
  String infoType;
  int size;
  int date;
  EpisodeModel({
    required this.id,
    required this.seasonId,
    required this.title,
    required this.episodeNumber,
    required this.path,
    required this.ext,
    required this.infoType,
    required this.size,
    required this.date,
  });

  factory EpisodeModel.createFilePath(
    String path, {
    required String seasonId,
    String? title,
    required int episodeNumber,
    required String infoType,
  }) {
    final file = File(path);
    return EpisodeModel(
      id: Uuid().v4(),
      seasonId: seasonId,
      title: title ?? file.path.getName(withExt: false),
      episodeNumber: episodeNumber,
      path: path,
      ext: file.path.getExt(),
      infoType: infoType,
      size: file.statSync().size,
      date: DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory EpisodeModel.fromMap(Map<String, dynamic> map) {
    return EpisodeModel(
      id: map['id'],
      seasonId: map['seasonId'],
      title: map['title'],
      episodeNumber: map['episodeNumber'],
      path: map['path'],
      ext: map['ext'],
      infoType: map['infoType'],
      size: map['size'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'seasonId': seasonId,
        'title': title,
        'episodeNumber': episodeNumber,
        'path': path,
        'ext': ext,
        'infoType': infoType,
        'size': size,
        'date': date,
      };

  @override
  String toString() {
    return 'title => $title - number -> $episodeNumber';
  }
}
