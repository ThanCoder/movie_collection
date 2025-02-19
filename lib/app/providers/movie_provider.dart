import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/models/video_file_model.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/video_provider.dart';
import 'package:movie_collections/app/services/movie_services.dart';
import 'package:movie_collections/app/utils/path_util.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:uuid/uuid.dart';

class MovieProvider with ChangeNotifier {
  static final String boxName = 'movies';
  final List<MovieModel> _list = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<MovieModel> get getMovieList => _list;
  String? initialDirectory;

  Future<void> initList({void Function(List<MovieModel> list)? onDone}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final movieList = Hive.box<MovieModel>(boxName).values.toList();
      //add provider
      _list.clear();
      _list.addAll(movieList);
      _isLoading = false;

      //sort
      _list.sort((a, b) => a.date.compareTo(b.date));
      //update
      notifyListeners();
      if (onDone != null) {
        onDone(_list);
      }
    } catch (e) {
      debugPrint('initMovieList: ${e.toString()}');
    }
  }

  Future<void> add({required MovieModel movie}) async {
    try {
      final box = Hive.box<MovieModel>(boxName);
      box.add(movie);
      //update notifier
      currentMovieNotifier.value = null;
      currentMovieNotifier.value = movie;
      //update provider
      _list.add(movie);
      notifyListeners();
    } catch (e) {
      debugPrint('add: ${e.toString()}');
    }
  }

  Future<void> addMultiple({required List<MovieModel> movieList}) async {
    try {
      final box = Hive.box<MovieModel>(boxName);
      box.addAll(movieList);
      //update provider
      _list.addAll(movieList);
      notifyListeners();
    } catch (e) {
      debugPrint('addMultiple: ${e.toString()}');
    }
  }

  Future<void> update({required MovieModel movie}) async {
    try {
      final box = Hive.box<MovieModel>(boxName);
      final index = box.values.toList().indexOf(movie);
      //update
      box.put(index, movie);
      //update notifier
      currentMovieNotifier.value = null;
      currentMovieNotifier.value = movie;
      //update provider
      _list[index] = movie;
      notifyListeners();
    } catch (e) {
      debugPrint('update: ${e.toString()}');
    }
  }

  Future<void> delete({required MovieModel movie}) async {
    try {
      final box = Hive.box<MovieModel>(boxName);
      final index = box.values.toList().indexOf(movie);
      //delete box
      box.deleteAt(index);
      //update provider
      _list.removeAt(index);
      notifyListeners();
    } catch (e) {
      debugPrint('deleteMovie: ${e.toString()}');
    }
  }

  void addMultipleMovieFromDirPath(String genres, String dirPath) async {
    try {
      _isLoading = true;
      notifyListeners();

      final files = Directory(dirPath).listSync();
      //filter already movie title
      final movieBox = Hive.box<MovieModel>(MovieProvider.boxName);
      final existingTitle = movieBox.values.map((mv) => mv.title).toSet();
      final filteredVideo = files.where((f) {
        if (f.statSync().type != FileSystemEntityType.file) {
          return false;
        }
        return !existingTitle.contains(getBasename(f.path).split('.').first);
      }).toList();
      //parse video list
      final videoList = filteredVideo.map((file) {
        //add db
        return VideoFileModel(
          id: Uuid().v4(),
          movidId: Uuid().v4(),
          title: getBasename(file.path).split('.').first,
          path: file.path,
          size: file.statSync().size,
          date: file.statSync().modified.millisecondsSinceEpoch,
        );
      }).toList();
      //gen movie
      final movieList = videoList
          .map(
            (vd) => MovieModel(
              id: vd.movidId,
              title: vd.title,
              year: DateTime.now().year,
              genres: genres,
            ),
          )
          .toList();
      //add database
      movieBox.addAll(movieList);
      //update provider
      _list.addAll(movieList);
      //add video
      await _addMultipleVideo(videoList: videoList);
      //gen cover
      await ThanPkg.platform.genVideoCover(
          outDirPath: getCachePath(),
          videoPathList: videoList.map((vd) => vd.path).toList());
      //copy cover
      for (final video in videoList) {
        final videoCover =
            File('${getCachePath()}/${video.title.split('.').first}.png');
        //exists cover
        if (await videoCover.exists()) {
          final movieCover =
              File(getMovieCoverSourcePath(movieId: video.movidId));
          await movieCover.writeAsBytes(await videoCover.readAsBytes());
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('addMultipleMovieFromDirPath: ${e.toString()}');
    }
  }

  void addMultipleMovieFromPath(String genres) async {
    try {
      _isLoading = true;
      notifyListeners();

      final files = await openFiles(
        initialDirectory: initialDirectory,
        acceptedTypeGroups: [
          XTypeGroup(
            label: 'video',
            mimeTypes: ['video/mp4'],
            extensions: ['mp4', 'mkv'],
          )
        ],
      );
      //filter already movie title
      if (files.isNotEmpty) {
        initialDirectory = File(files.first.path).parent.path;
      }

      final movieBox = Hive.box<MovieModel>(MovieProvider.boxName);
      final existingTitle = movieBox.values.map((mv) => mv.title).toSet();
      final filteredVideo = files.where((f) {
        return !existingTitle.contains(f.name.split('.').first);
      }).toList();
      //parse video list
      final videoList = filteredVideo.map((file) {
        final f = File(file.path);
        //add db
        return VideoFileModel(
          id: Uuid().v4(),
          movidId: Uuid().v4(),
          title: getBasename(file.path).split('.').first,
          path: file.path,
          size: f.statSync().size,
          date: f.statSync().modified.millisecondsSinceEpoch,
        );
      }).toList();
      //gen movie
      final movieList = videoList
          .map(
            (vd) => MovieModel(
              id: vd.movidId,
              title: vd.title,
              year: DateTime.now().year,
              genres: genres,
            ),
          )
          .toList();
      //add database
      movieBox.addAll(movieList);
      //update provider
      _list.addAll(movieList);
      //add video
      await _addMultipleVideo(videoList: videoList);
      //gen cover
      await ThanPkg.platform.genVideoCover(
          outDirPath: getCachePath(),
          videoPathList: videoList.map((vd) => vd.path).toList());
      //copy cover
      for (final video in videoList) {
        final videoCover =
            File('${getCachePath()}/${video.title.split('.').first}.png');
        //exists cover
        if (await videoCover.exists()) {
          final movieCover =
              File(getMovieCoverSourcePath(movieId: video.movidId));
          await movieCover.writeAsBytes(await videoCover.readAsBytes());
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('addMultipleMovieFromPath: ${e.toString()}');
    }
  }

  Future<void> _addMultipleVideo(
      {required List<VideoFileModel> videoList}) async {
    try {
      final box = Hive.box<VideoFileModel>(VideoProvider.boxName);
      box.addAll(videoList);
    } catch (e) {
      debugPrint('addMultiple: ${e.toString()}');
    }
  }
}
