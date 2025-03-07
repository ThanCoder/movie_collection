// ignore_for_file: public_member_api_docs, sort_constructors_first
class SeriesModel {
  String id;
  String movieId;
  String title;
  int size;
  int date;

  String path;
  String coverPath;

  SeriesModel({
    required this.id,
    required this.movieId,
    required this.title,
    required this.size,
    required this.date,
    this.path = '',
    this.coverPath = '',
  });

  factory SeriesModel.fromMap(Map<String, dynamic> map) {
    return SeriesModel(
      id: map['id'],
      movieId: map['movie_id'],
      title: map['title'],
      size: map['size'],
      date: map['date'],
    );
  }
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'movie_id': movieId,
        'size': size,
        'date': date,
      };
}
