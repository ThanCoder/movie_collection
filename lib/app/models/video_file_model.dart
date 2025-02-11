// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:movie_collections/app/utils/path_util.dart';

part 'video_file_model.g.dart';

@HiveType(typeId: 2)
class VideoFileModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String movidId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String path;

  @HiveField(4)
  int size;

  @HiveField(5)
  int date;

  late String coverPath;
  bool isSelected = false;

  VideoFileModel({
    required this.id,
    required this.movidId,
    required this.title,
    required this.path,
    required this.size,
    required this.date,
  }) {
    String name = getBasename(path);
    coverPath = '${getCachePath()}/${name.split('.').first}.png';
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'path': path,
        'size': size,
        'date': date,
      };

  @override
  String toString() {
    return '\ntitle => $title';
  }
}
