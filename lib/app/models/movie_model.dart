// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 1)
class MovieModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String genres;

  @HiveField(3, defaultValue: '')
  String description;

  @HiveField(4, defaultValue: 1.0)
  double imdb;

  @HiveField(5)
  int durationInMinutes;

  @HiveField(6, defaultValue: '')
  String posterUrl;

  @HiveField(7, defaultValue: '')
  String trailerUrl;

  @HiveField(8, defaultValue: false)
  bool isMultipleMovie;

  @HiveField(9)
  int year;

  @HiveField(10)
  late int date;

  bool isSelected = false;

  MovieModel({
    required this.id,
    required this.title,
    required this.year,
    this.isMultipleMovie = false,
    this.genres = '',
    this.description = '',
    this.durationInMinutes = 0,
    this.imdb = 1.0,
    this.posterUrl = '',
    this.trailerUrl = '',
  }) {
    date = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  String toString() {
    return '\nid => $id\ntitle => $title\ngenres => $genres\ndesc => $description\n';
  }

  static List<String> getFields() =>
      ['ID', 'Title', 'IMDB', 'Year', 'Multiple', 'Duration', 'Date'];
}
