// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'movie_model.dart';

class ResultScreenData {
  String title;
  List<MovieModel> list;

  ResultScreenData({required this.title, required this.list});

  factory ResultScreenData.empty() {
    return ResultScreenData(title: '', list: []);
  }

  ResultScreenData copyWith({
    String? title,
    List<MovieModel>? list,
  }) {
    return ResultScreenData(
      title: title ?? this.title,
      list: list ?? this.list,
    );
  }

  ResultScreenData removeListItem(MovieModel movie) {
    final res = list.where((e) => e.title != movie.title).toList();
    return ResultScreenData(title: title, list: res);
  }
}
