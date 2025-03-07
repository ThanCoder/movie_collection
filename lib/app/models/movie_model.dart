// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_collections/app/utils/path_util.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class MovieModel {
  static String get getName => 'movies';
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String type;
  @HiveField(3)
  String infoType;
  @HiveField(4)
  String path;
  @HiveField(5)
  String tags;
  @HiveField(6)
  int date;
  @HiveField(7, defaultValue: 0)
  int size;

  String content;
  String coverPath = '';
  bool isSelected = false;

  MovieModel({
    required this.id,
    required this.title,
    required this.path,
    this.content = '',
    this.tags = '',
    required this.type,
    required this.infoType,
    required this.date,
    required this.size,
  });

  String getSourcePath() {
    return '${PathUtil.instance.getDatabaseSourcePath()}/$id/$id';
  }

  @override
  String toString() {
    return title;
  }
}
