import 'package:hive/hive.dart';

import 'episode.dart';

part 'season.g.dart';

@HiveType(typeId: 3)
class Season {
  static String dbName = 'season';
  static Box<Season> get db => Hive.box<Season>(dbName);

  @HiveField(0)
  final String id;

  @HiveField(1)
  final int seasonNumber;

  @HiveField(2)
  final List<Episode> episodes;

  Season({
    required this.id,
    required this.seasonNumber,
    required this.episodes,
  });

  Future<void> delete() async {
    for (var ep in episodes) {
      await ep.delete();
    }
  }
}
