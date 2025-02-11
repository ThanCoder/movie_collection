import 'package:hive/hive.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/utils/path_util.dart';

String getCurrentMovieSourcePath() {
  final movie = currentMovieNotifier.value!;
  return createDir('${getDatabaseSourcePath()}/${movie.id}');
}

String getMovieCoverSourcePath({required String movieId}) {
  final path = createDir('${getDatabaseSourcePath()}/$movieId');
  return '$path/cover.png';
}

Future<void> addMovie({required MovieModel movie}) async {
  final box = Hive.box<MovieModel>('movies');
  box.add(movie);
}

Future<void> updateMovie({required MovieModel movie}) async {
  final box = Hive.box<MovieModel>('movies');
  final index = box.values.toList().indexOf(movie);
  box.put(index, movie);
}

Future<void> deleteMovie({required MovieModel movie}) async {
  final box = Hive.box<MovieModel>('movies');
  final index = box.values.toList().indexOf(movie);
  //delete box
  box.delete(index);
}
