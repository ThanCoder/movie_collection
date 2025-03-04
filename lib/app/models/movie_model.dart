// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/hive_flutter.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class MovieModel {
  static String get getName => 'movies';
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String content;
  @HiveField(3)
  String type;
  @HiveField(4)
  String infoType;
  @HiveField(5)
  String path;
  @HiveField(6)
  String tags;
  @HiveField(7)
  int date;

  MovieModel({
    required this.id,
    required this.title,
    this.path = '',
    this.content = '',
    this.tags = '',
    required this.type,
    required this.infoType,
    required this.date,
  });

  @override
  String toString() {
    return title;
  }
}
