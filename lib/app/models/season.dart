import 'dart:io';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'episode.dart';

part 'season.g.dart';

@HiveType(typeId: 3)
class Season {
  static String dbName = 'season';
  static Box<Season> get db => Hive.box<Season>(dbName);

  @HiveField(0)
  String id;

  @HiveField(1)
  int seasonNumber;

  @HiveField(2)
  List<Episode> episodes;

  Season({
    required this.id,
    required this.seasonNumber,
    required this.episodes,
  });

  factory Season.create(int seasonNumber, {required List<Episode> episodes}) {
    return Season(
      id: Uuid().v4(),
      seasonNumber: seasonNumber,
      episodes: episodes,
    );
  }
  Future<void> deleteEpisode(Episode ep) async {
    await ep.delete();
    episodes =
        episodes.where((e) => e.episodeNumber != ep.episodeNumber).toList();
  }

  Future<void> delete() async {
    for (var ep in episodes) {
      await ep.delete();
    }
  }

  double get getSize {
    double size = 0;
    for (var ep in episodes) {
      final file = File(ep.filePath);
      if (!file.existsSync()) return 0;
      size += file.statSync().size.toDouble();
    }
    return size;
  }

  @override
  String toString() {
    return '$seasonNumber';
  }
}
