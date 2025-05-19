import 'dart:io';

import 'package:hive/hive.dart';
import 'package:mc_v2/models/info_type.dart';
import 'package:mc_v2/models/season.dart';
import 'package:mc_v2/models/video_type.dart';
import 'package:mc_v2/my_libs/setting/path_util.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:uuid/uuid.dart';

part 'video_item.g.dart';

@HiveType(typeId: 1)
class VideoItem {
  static String dbName = 'video_item';
  static Box<VideoItem> get db => Hive.box<VideoItem>(dbName);

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final VideoType type; // music,movie,series

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String filePath;

  @HiveField(5)
  final String coverPath;

  @HiveField(6)
  final DateTime date;

  @HiveField(7)
  final List<Season> seasons; // for series only

  @HiveField(8)
  final InfoType infoType; //for real data or info data

  @HiveField(9)
  final List<String> genres; // e.g. Action, Romance

  @HiveField(10)
  final List<String> tags; // e.g. trending, award-winning

  @HiveField(11)
  final String ext;

  @HiveField(12)
  final String mime;

  @HiveField(13)
  final List<String> contentImages;

  VideoItem({
    required this.id,
    required this.title,
    required this.type,
    required this.infoType,
    required this.filePath,
    required this.coverPath,
    required this.date,
    required this.ext,
    required this.mime,
    this.description = '',
    this.seasons = const [],
    this.genres = const [],
    this.tags = const [],
    this.contentImages = const [],
  });

  factory VideoItem.fromPath(
    String path, {
    VideoType type = VideoType.movie,
    InfoType infoType = InfoType.info,
  }) {
    final id = Uuid().v4();

    return VideoItem(
      id: id,
      title: path.getName(withExt: false),
      type: type,
      infoType: infoType,
      filePath: path,
      coverPath: '${PathUtil.getDatabaseSourcePath()}/$id.png',
      date: DateTime.now(),
      ext: path.getExt(),
      mime: lookupMimeType(path) ?? '',
    );
  }

  Future<void> add() async {
    // return await db.add(this);
    await db.put(id, this);
  }

  Future<void> delete() async {
    await db.delete(id);
    //remove video
    final cf = File(coverPath);

    if (await cf.exists()) {
      await cf.delete();
    }
    if (infoType == InfoType.realData) {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }

    //delete season
    for (var season in seasons) {
      await season.delete();
    }
  }

  String get getSizeLable {
    final file = File(filePath);
    if (!file.existsSync()) return '';
    return file.statSync().size.toDouble().toFileSizeLabel();
  }

  //static
  static Future<void> addMultiple(List<VideoItem> list) async {
    // return await db.addAll(list);
    for (var video in list) {
      await db.put(video.id, video);
    }
  }

  Future<void> update(VideoItem video) async {
    final index = db.values.toList().indexWhere((e) => e.id == video.id);
    await db.putAt(index, video);
  }

  static VideoItem? getId(String id) {
    // final index = db.values.toList().indexWhere((e) => e.id == id);
    return db.get(id);
  }

  static List<VideoItem> getLatest() {
    final res = db.values.toList();
    res.sort((a, b) {
      if (a.date.millisecondsSinceEpoch > b.date.millisecondsSinceEpoch) {
        return -1;
      }
      if (a.date.millisecondsSinceEpoch < b.date.millisecondsSinceEpoch) {
        return 1;
      }
      return 0;
    });
    return res;
  }
}
