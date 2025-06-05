import 'package:hive/hive.dart';

part 'video_type.g.dart';

@HiveType(typeId: 0)
enum VideoType {
  @HiveField(0)
  movie,

  @HiveField(1)
  series,

  @HiveField(2)
  music,

  @HiveField(3)
  porn;

  static const defaultValue = VideoType.movie;

  static List<VideoType> get getList => VideoType.values;
}
