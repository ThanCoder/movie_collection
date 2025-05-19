import 'dart:io';

import 'package:hive/hive.dart';
import 'package:mc_v2/models/info_type.dart';

part 'episode.g.dart';

@HiveType(typeId: 2)
class Episode {
  static String dbName = 'episode';
  static Box<Episode> get db => Hive.box<Episode>(dbName);

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String filePath;

  @HiveField(3)
  final int episodeNumber;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final InfoType infoType;

  Episode({
    required this.id,
    required this.title,
    required this.filePath,
    required this.episodeNumber,
    this.description = '',
    this.infoType = InfoType.info,
  });

  Future<void> delete() async {
    if (infoType == InfoType.realData) {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}
