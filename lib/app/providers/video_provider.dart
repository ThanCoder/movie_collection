import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_collections/app/models/video_file_model.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/services/movie_services.dart';
import 'package:movie_collections/app/utils/path_util.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:uuid/uuid.dart';

class VideoProvider with ChangeNotifier {
  static final String boxName = 'videos';
  final List<VideoFileModel> _list = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<VideoFileModel> get getList => _list;

  String? initialDirectory;

  Future<void> initList({required String movieId}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final list = Hive.box<VideoFileModel>(boxName)
          .values
          .where((mv) => mv.movidId == movieId)
          .toList();

      //add provider
      _list.clear();
      _list.addAll(list);
      _isLoading = false;
      //gen cover
      await genVideoCover();

      notifyListeners();
    } catch (e) {
      debugPrint('initList: ${e.toString()}');
    }
  }

  Future<void> add({required VideoFileModel video}) async {
    try {
      final box = Hive.box<VideoFileModel>(boxName);
      box.add(video);
      //update provider
      _list.add(video);
      //gen cover
      await genVideoCover();

      notifyListeners();
    } catch (e) {
      debugPrint('add: ${e.toString()}');
    }
  }

  Future<void> addMultiple({required List<VideoFileModel> videoList}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final box = Hive.box<VideoFileModel>(boxName);
      box.addAll(videoList);
      //update provider
      _list.addAll(videoList);
      //gen cover
      await genVideoCover();
      _isLoading = false;

      notifyListeners();
    } catch (e) {
      debugPrint('addMultiple: ${e.toString()}');
    }
  }

  Future<void> update({required VideoFileModel video}) async {
    try {
      final box = Hive.box<VideoFileModel>(boxName);
      final index = box.values.toList().indexOf(video);
      //update
      box.put(index, video);
      //update provider
      _list[index] = video;
      //gen cover
      await genVideoCover();

      notifyListeners();
    } catch (e) {
      debugPrint('update: ${e.toString()}');
    }
  }

  Future<void> delete({required VideoFileModel video}) async {
    try {
      final box = Hive.box<VideoFileModel>(boxName);
      //delete box
      box.deleteAt(box.values.toList().indexOf(video));
      //update provider
      _list.removeAt(_list.indexOf(video));

      //delete file
      final file = File('${getCurrentMovieSourcePath()}/${video.id}');
      if (await file.exists()) {
        await file.delete();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('delete: ${e.toString()}');
    }
  }

  Future<void> genVideoCover() async {
    try {
      if (_list.isEmpty) return;

      final videoPathList = _list.map((vd) => vd.path).toList();
      await ThanPkg.platform.genVideoCover(
          outDirPath: getCachePath(), videoPathList: videoPathList);

      notifyListeners();
    } catch (e) {
      debugPrint('genVideoCover: ${e.toString()}');
    }
  }

  Future<void> addMultipleVideoFromChooser() async {
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
      final box = Hive.box<VideoFileModel>(boxName);
      //ခုလောလောဆယ် movie id ကိုရယူတယ်
      final movidId = currentMovieNotifier.value!.id;
      //current movie id ရဲ့ video ကိုစစ်ထုတ်တယ်
      final currentMovieVideoList =
          box.values.where((vd) => vd.movidId == movidId);
      //title list သက်သက် ပြောင်းလဲတယ်
      final dbTitleList = currentMovieVideoList.map((vd) => vd.title).toSet();
      //choose file တွေကို ရှိနေပြီး စစ်ထုတ်တယ်
      final filterdFiles = files.where((file) {
        return !dbTitleList.contains(file.name.split('.').first);
      }).toList();
      //စစ်ထုတ်ပြီးသားတွေကို video list ပြောင်းလဲတယ်
      final videoList = filterdFiles.map((file) {
        final f = File(file.path);
        final title = file.name.split('.').first;
        return VideoFileModel(
          id: Uuid().v4(),
          movidId: movidId,
          title: title,
          path: file.path,
          size: f.statSync().size,
          date: f.statSync().modified.millisecondsSinceEpoch,
        );
      }).toList();

      //add db
      box.addAll(videoList);
      //update provider
      _list.addAll(videoList);
      //gen cover
      await genVideoCover();
      //loading
      _isLoading = false;

      notifyListeners();
    } catch (e) {
      debugPrint('addMultiple: ${e.toString()}');
    }
  }
}
