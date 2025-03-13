import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_collections/app/dialogs/core/index.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/extensions/string_extension.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/notifiers/app_notifier.dart';
import 'package:movie_collections/app/services/movie_services.dart';
import 'package:movie_collections/app/utils/path_util.dart';
import 'package:real_path_file_selector/real_path_file_selector.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:uuid/uuid.dart';

class MovieProvider with ChangeNotifier {
  final List<MovieModel> _list = [];
  MovieModel? _movie;
  bool _isLoading = false;

  List<MovieModel> get getList => _list;
  bool get isLoading => _isLoading;
  MovieModel? get getCurrent => _movie;

  late Box<MovieModel> _box;

  MovieProvider() {
    _box = Hive.box<MovieModel>(MovieModel.getName);
  }

  void restoreMovieFile(BuildContext context,
      {required MovieModel movie, required VoidCallback onDoned}) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        contentText:
            '`${movie.title}` file ကို Restore လုပ်ချင်ပါသလား?\n\nRestore လုပ်ရင် Database ကိုပါ ဖျက်ပစ်ပါမယ်!.',
        submitText: 'Restore',
        onCancel: () {},
        onSubmit: () async {
          try {
            final file = File(movie.getSourcePath());
            if (!await file.exists()) return;
            _isLoading = true;
            notifyListeners();
            String restorePath =
                '${PathUtil.instance.getOutPath()}/${movie.title}.mp4';
            //move
            await file.rename(restorePath);

            //remove db
            delete(movie);

            _isLoading = false;
            notifyListeners();

            onDoned();
          } catch (e) {
            _isLoading = false;
            notifyListeners();
            debugPrint(e.toString());
          }
        },
      ),
    );
  }

  void deleteMovieFile(BuildContext context, MovieModel movie) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        contentText: 'video file ကိုဖျက်ချင်ပါသလား?',
        submitText: 'Delete File',
        onCancel: () {},
        onSubmit: () async {
          try {
            final file = File('${movie.getSourcePath()}/${movie.id}');
            if (!await file.exists()) return;
            _isLoading = true;
            notifyListeners();

            await file.delete();

            _isLoading = false;
            notifyListeners();
          } catch (e) {
            _isLoading = false;
            notifyListeners();
            debugPrint(e.toString());
          }
        },
      ),
    );
  }

  Future<void> addVideoFromPathWithInfoType(
    BuildContext context,
  ) async {
    try {
      final movie = _movie!;
      if (movie.infoType != MovieInfoTypes.data.name) return;
      String path = '';
      // _isLoading = true;
      // notifyListeners();

      if (Platform.isLinux) {
        final file = await openFile(
          acceptedTypeGroups: [
            XTypeGroup(extensions: ['.mp4', '.mkv'], mimeTypes: ['video/mp4']),
          ],
        );
        if (file == null) return;
        path = file.path;
      } else if (Platform.isAndroid) {
        final res = await RealPathFileSelector.openFileScanner.open(
          context,
          mimeType: 'video',
          title: 'Choose Movie',
          // thumbnailDirPath: PathUtil.instance.getCachePath(),
        );
        if (res.isEmpty) return;
        path = res.first;
      }
      //video path ရလာရင်
      final newFile = File(path);
      if (!newFile.existsSync()) return;
      await newFile.rename(movie.getSourcePath());

      movie.path = '${movie.getSourcePath()}/${movie.id}';
      _movie = movie;

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      debugPrint(e.toString());
    }
  }

  Future<void> delete(MovieModel movie) async {
    try {
      _isLoading = true;
      notifyListeners();

      final index = _list.indexWhere((mv) => mv.id == movie.id);
      final dbIndex =
          _box.values.toList().indexWhere((mv) => mv.id == movie.id);
      //ui
      _list.removeAt(index);
      //db
      await _box.deleteAt(dbIndex);
      //delete folder
      await MovieServices.instance.deleteMovieFullInfo(movie);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('delete: ${e.toString()}');
    }
  }

  Future<void> update(MovieModel movie) async {
    try {
      _isLoading = true;
      notifyListeners();

      _movie = movie;

      // final index = _list.indexWhere((mv) => mv.id == movie.id);
      final dbIndex =
          _box.values.toList().indexWhere((mv) => mv.id == movie.id);
      // await _box.put(id, movie);
      // print(_box.get(index));
      await _box.putAt(dbIndex, movie);
      //set fullcontent
      await MovieServices.instance.setMovieFullInfo(movie);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('update: ${e.toString()}');
    }
  }

  Future<void> setCurrent(MovieModel movie) async {
    try {
      _isLoading = true;
      notifyListeners();

      _movie = await MovieServices.instance.getMovieFullInfo(movie);
      // await Future.delayed(Duration(milliseconds: 1200));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('setCurrent: ${e.toString()}');
    }
  }

  Future<List<MovieModel>> initList() async {
    try {
      _isLoading = true;
      notifyListeners();

      final cachePath = PathUtil.instance.getCachePath();
      final databaseSourcePath = PathUtil.instance.getDatabaseSourcePath();

      _list.clear();
      var res = _box.values.map((mv) {
        mv.coverPath = '$databaseSourcePath/${mv.id}/cover.png';
        if (mv.infoType == MovieInfoTypes.data.name) {
          mv.path = '$databaseSourcePath/${mv.id}/${mv.id}';
        }
        return mv;
      }).toList();

      res.sort((a, b) {
        if (a.date > b.date) return -1;
        if (a.date < b.date) return 1;
        return 0;
      });

      if (appConfigNotifier.value.isOnlyShowExistsMovieFile) {
        res = res.where((vd) => File(vd.path).existsSync()).toList();
      }

      _list.addAll(res);

      final noExistsCover = _list.where((vd) {
        final file = File(vd.coverPath);
        return !file.existsSync();
      }).toList();

      //cover gen
      await ThanPkg.platform.genVideoCover(
        outDirPath: cachePath,
        videoPathList: noExistsCover.map((vd) => vd.path).toList(),
      );
      final dbSourcePath = PathUtil.instance.getDatabaseSourcePath();
      //copy file
      for (var vd in noExistsCover) {
        final coverFile = File('$dbSourcePath/${vd.id}/cover.png');
        final cacheCoverFile =
            File('$cachePath/${vd.path.getName(withExt: false)}.png');
        if (!await cacheCoverFile.exists()) {
          continue;
        }
        if (await coverFile.exists()) continue;
        //ရှိနေရင်
        await cacheCoverFile.copy(coverFile.path);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('initList: ${e.toString()}');
    }
    return _list;
  }

  Future<void> add({required MovieModel movie}) async {
    try {
      _isLoading = true;
      notifyListeners();

      _list.insert(0, movie);
      _box.add(movie);
      _movie = movie;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('add: ${e.toString()}');
    }
  }

  Future<void> addFromPathList({
    required List<String> pathList,
    required MovieTypes movieType,
    required MovieInfoTypes movieInfoType,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final cachePath = PathUtil.instance.getCachePath();
      final databaseSourcePath = PathUtil.instance.getDatabaseSourcePath();

      //exsits title
      final existsTitle = _list.map((mv) => mv.title).toSet();

      //movie path ကို loop မယ်
      for (var path in pathList) {
        //check title
        final title = path.getName(withExt: false);
        if (existsTitle.contains(title)) {
          debugPrint('already exists: $title');
          continue;
        }
        //မရှိသေးတာ
        final newMovie = MovieModel(
          id: Uuid().v4(),
          title: title,
          path: path,
          type: movieType.name,
          infoType: movieInfoType.name,
          date: DateTime.now().millisecondsSinceEpoch,
          size: File(path).statSync().size,
        );
        //add db
        _box.add(newMovie);

        //movie source dir path
        final source =
            PathUtil.instance.createDir('$databaseSourcePath/${newMovie.id}');

        //copy cover
        final cacheCoverFile = File('$cachePath/$title.png');
        if (await cacheCoverFile.exists()) {
          await cacheCoverFile.copy('$source/cover.png');
        }
        //check movie type
        if (newMovie.infoType == MovieInfoTypes.data.name) {
          //သူက movie file ကို move မယ်
          final movieFile = File(path);
          await movieFile.rename('$source/${newMovie.id}');
        }
      }

      initList();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('add: ${e.toString()}');
    }
  }
}
