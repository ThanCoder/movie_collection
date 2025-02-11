import 'package:hive/hive.dart';

part 'genres_model.g.dart';

@HiveType(typeId: 0)
class GenresModel {
  @HiveField(0)
  String id;

  @HiveField(2)
  String title;

  @HiveField(3)
  int date;

  bool isSelected;
  int count;

  GenresModel({
    required this.id,
    required this.title,
    required this.date,
    this.isSelected = false,
    this.count = 0,
  });

  factory GenresModel.fromMap(Map<String, dynamic> map) {
    return GenresModel(
      id: map['id'],
      title: map['title'],
      date: map['date'],
    );
  }
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'date': date,
      };

  @override
  String toString() {
    return '\nid => $id\ntitle => $title\ndate => $date\n';
  }
}
