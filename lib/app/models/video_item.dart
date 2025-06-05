import 'dart:io';

import 'package:hive/hive.dart';
import 'package:mc_v2/app/models/info_type.dart';
import 'package:mc_v2/app/models/season.dart';
import 'package:mc_v2/app/models/video_type.dart';
import 'package:mc_v2/my_libs/setting/path_util.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:uuid/uuid.dart';

part 'video_item.g.dart';

@HiveType(typeId: 1)
class VideoItem {
  static String dbName = 'video_item';
  static Box<VideoItem> get db => Hive.box<VideoItem>(dbName);

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  VideoType type; // music,movie,series

  @HiveField(3)
  String description;

  @HiveField(4)
  String filePath;

  @HiveField(5)
  String coverPath;

  @HiveField(6)
  DateTime date;

  @HiveField(7)
  List<Season> seasons; // for series only

  @HiveField(8)
  InfoType infoType; //for real data or info data

  @HiveField(9)
  List<String> genres; // e.g. Action, Romance

  @HiveField(10)
  List<String> tags; // e.g. trending, award-winning

  @HiveField(11)
  String ext;

  @HiveField(12)
  String mime;

  @HiveField(13)
  List<String> contentImages;

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
    required this.contentImages,
    required this.genres,
    required this.seasons,
    required this.tags,
    this.description = '',
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
      contentImages: [],
      genres: [],
      seasons: [],
      tags: [],
    );
  }

  factory VideoItem.createSeries(
    String title, {
    VideoType type = VideoType.series,
    InfoType infoType = InfoType.info,
  }) {
    final id = Uuid().v4();

    return VideoItem(
      id: id,
      title: title,
      type: type,
      infoType: infoType,
      filePath: '',
      coverPath: '${PathUtil.getDatabaseSourcePath()}/$id.png',
      date: DateTime.now(),
      ext: '',
      mime: '',
      contentImages: [],
      genres: [],
      seasons: [],
      tags: [],
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

  // not work season
  Future<void> restore() async {
    await db.delete(id);
    //restore video
    final cf = File(coverPath);

    if (await cf.exists()) {
      await cf.rename('${PathUtil.getOutPath()}/$title.$ext');
    }
  }

  String get getSizeLable {
    if (type == VideoType.series) {
      double size = 0;
      for (var season in seasons) {
        size += season.getSize;
      }
      return size.toFileSizeLabel();
    }
    // is single video
    final file = File(filePath);
    if (!file.existsSync()) return '';
    return file.statSync().size.toDouble().toFileSizeLabel();
  }

  bool get isExists {
    final file = File(filePath);
    return file.existsSync();
  }

  // season
  void addSeason(Season season) {
    seasons.add(season);
  }

  bool isSeasonExists(int number) {
    final res = seasons.where((e) => e.seasonNumber == number);
    return res.isNotEmpty;
  }

  Season? get getLatestSeason {
    if (seasons.isEmpty) return null;
    seasons.sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));
    return seasons.last;
  }

  //static
  static Future<void> addMultiple(
    List<VideoItem> list, {
    bool isExistsSkip = true,
    InfoType infoType = InfoType.info,
    VideoType videoType = VideoType.movie,
  }) async {
    for (var video in list) {
      video.type = videoType;
      video.infoType = infoType;

      if (isExistsSkip && isExistsTitle(video.title)) continue;
      // is real data
      if (infoType == InfoType.realData) {
        //move video file
        final file = File(video.filePath);
        final newPath =
            '${PathUtil.getDatabaseSourcePath()}/${video.id}.${video.ext}';
        await file.rename(newPath);
        video.filePath = newPath;
      }
      // add db
      await db.put(video.id, video);
    }
  }

  Future<void> update(VideoItem video) async {
    final index = db.values.toList().indexWhere((e) => e.id == video.id);
    await db.putAt(index, video);
  }

  static VideoItem? getId(String id) {
    return db.get(id);
  }

  static bool isExistsTitle(String title) {
    final res = db.values.where((e) => e.title == title).toList();
    return res.isNotEmpty;
  }

  static List<VideoItem> getList({
    bool isExistsFile = true,
  }) {
    final res = db.values.toList();

    if (isExistsFile) {
      return res.where((e) {
        // series
        if (e.type == VideoType.series) {
          return true;
        }
        return e.isExists;
      }).toList();
    }
    //not exits
    return res.where((e) {
      // series
      if (e.type == VideoType.series) {
        return false;
      }
      return !e.isExists;
    }).toList();
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

  @override
  String toString() {
    return title;
  }
}
