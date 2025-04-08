import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_collections/app/dialogs/core/index.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/extensions/string_extension.dart';
import 'package:movie_collections/app/models/episode_model.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/models/season_model.dart';
import 'package:movie_collections/app/notifiers/app_notifier.dart';
import 'package:movie_collections/app/services/movie_content_cover_serices.dart';
import 'package:movie_collections/app/services/movie_season_services.dart';
import 'package:movie_collections/app/services/movie_services.dart';
import 'package:movie_collections/app/utils/path_util.dart';
import 'package:real_path_file_selector/real_path_file_selector.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:than_pkg/types/src_dist_type.dart';
import 'package:uuid/uuid.dart';

class MovieProvider with ChangeNotifier {
  // static final MovieProvider instance = MovieProvider._();
  // MovieProvider._();
  // factory MovieProvider() => instance;

  final List<MovieModel> _list = [];
  MovieModel? _movie;
  bool _isLoading = false;

  List<MovieModel> get getList => _list;
  bool get isLoading => _isLoading;
  MovieModel? get getCurrent => _movie;
  static Box<MovieModel> get getDB => Hive.box<MovieModel>(MovieModel.getName);

  late Box<MovieModel> _box;

  MovieProvider() {
    _box = Hive.box<MovieModel>(MovieModel.getName);
  }

  Future<List<MovieModel>> initList({bool isReset = false}) async {
    try {
      if (isReset == false && _list.isNotEmpty) {
        return _list;
      }
      _isLoading = true;
      notifyListeners();

      // final cachePath = PathUtil.instance.getCachePath();
      final databaseSourcePath = PathUtil.instance.getDatabaseSourcePath();

      _list.clear();
      // var res = _box.values.toList();
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

      final noExistsCoverList = _list.where((vd) {
        final file = File(vd.coverPath);
        return !file.existsSync();
      }).toList();

      final genList = noExistsCoverList
          .map((movie) => SrcDistType(
                src: movie.path,
                dist: movie.coverPath,
              ))
          .toList();
      await ThanPkg.platform.genVideoThumbnail(pathList: genList);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('initList: ${e.toString()}');
    }
    return _list;
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
                '${PathUtil.instance.getOutPath()}/${movie.title}.${movie.ext.isEmpty ? 'mp4' : movie.ext}';
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

  Future<void> deleteMultiple(List<MovieModel> list) async {
    try {
      _isLoading = true;
      notifyListeners();

      for (var movie in list) {
        final index = _list.indexWhere((mv) => mv.id == movie.id);
        final dbIndex =
            _box.values.toList().indexWhere((mv) => mv.id == movie.id);
        //ui
        _list.removeAt(index);
        //db
        await _box.deleteAt(dbIndex);
        //delete folder
        await MovieServices.instance.deleteMovieFullInfo(movie);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('deleteMultiple: ${e.toString()}');
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
      initContentCoverList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('setCurrent: ${e.toString()}');
    }
  }

  Future<void> add({required MovieModel movie}) async {
    try {
      _isLoading = true;
      notifyListeners();

      _list.insert(0, movie);
      _box.add(movie);
      // set current
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
    required String tags,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // final cachePath = PathUtil.instance.getCachePath();
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
          tags: tags,
          path: path,
          type: movieType.name,
          infoType: movieInfoType.name,
          date: DateTime.now().millisecondsSinceEpoch,
          size: File(path).statSync().size,
          ext: path.getExt(),
        );
        //add db
        _box.add(newMovie);

        //movie source dir path
        final source =
            PathUtil.instance.createDir('$databaseSourcePath/${newMovie.id}');

        //gen cover
        // final genList =
        //     pathList.map((path) => SrcDistType(src: path, dist: '')).toList();
        // await ThanPkg.platform.genVideoThumbnail(pathList: genList);
        //check movie type
        if (newMovie.infoType == MovieInfoTypes.data.name) {
          //သူက movie file ကို move မယ်
          final movieFile = File(path);
          await movieFile.rename('$source/${newMovie.id}');
        }
      }
      initList(isReset: true);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('add: ${e.toString()}');
    }
  }

  //movie content cover
  List<String> contentCoverList = [];

  void addContentCover({required List<String> pathList}) async {
    _isLoading = true;
    notifyListeners();

    await MovieContentCoverSerices.instance.add(
      movieId: getCurrent!.id,
      pathList: pathList,
    );
    initContentCoverList();
  }

  void initContentCoverList() async {
    _isLoading = true;
    notifyListeners();

    contentCoverList =
        await MovieContentCoverSerices.instance.getList(getCurrent!.id);
    _isLoading = false;
    notifyListeners();
  }

  //movie season list
  List<SeasonModel> seasonList = [];
  void intSeasonList() async {
    _isLoading = true;
    notifyListeners();

    seasonList = await MovieSeasonServices.instance.getList(getCurrent!.id);
    // sort
    seasonList.sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));

    _isLoading = false;
    notifyListeners();
  }

  void addSeason({required int seasonNumber, String title = 'Untitled'}) async {
    _isLoading = true;
    notifyListeners();

    final season = SeasonModel.create(
      movieId: getCurrent!.id,
      title: title,
      seasonNumber: seasonNumber,
    );

    seasonList.add(season);

    await MovieSeasonServices.instance
        .setList(getCurrent!.id, list: seasonList);
    intSeasonList();
  }

  void setSeasonList(
      {required int seasonNumber, required List<SeasonModel> list}) async {
    _isLoading = true;
    notifyListeners();

    await MovieSeasonServices.instance.setList(getCurrent!.id, list: list);
    intSeasonList();
  }

  //episode
  void addEpisodesPathList({
    required String seasonId,
    required String infoType,
    required List<String> pathList,
  }) async {
    try {
      final seasonIndex = seasonList.indexWhere((se) => se.id == seasonId);
      final season = seasonList[seasonIndex];
      _isLoading = true;
      notifyListeners();

      int epLatestNumber =
          season.episodes.isEmpty ? 0 : season.episodes.last.episodeNumber;
      for (var path in pathList) {
        final ep = EpisodeModel.createFilePath(
          path,
          seasonId: seasonId,
          episodeNumber: epLatestNumber + 1,
          infoType: infoType,
        );
        //add
        if (ep.infoType == MovieInfoTypes.data.name) {
          //real data file
          final file = File(ep.path);
          if (await file.exists()) {
            //copy
            final newPath =
                MovieSeasonServices.getVideoPath(getCurrent!.id, ep);
            await file.rename(newPath);
          }
        }

        season.episodes.add(ep);
        epLatestNumber++;
      }

      //set resset ui
      seasonList[seasonIndex] = season;

      await MovieSeasonServices.instance
          .setList(getCurrent!.id, list: seasonList);
      intSeasonList();
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void deleteEpisode(SeasonModel season, EpisodeModel episode) async {
    try {
      final videoPath =
          MovieSeasonServices.getVideoPath(getCurrent!.id, episode);
      final videoFile = File(videoPath);
      if (await videoFile.exists()) {
        await videoFile.delete();
      }

      final index = seasonList.indexWhere((se) => se.id == season.id);
      final epList =
          season.episodes.where((ep) => ep.id != episode.id).toList();
      //sort
      epList.sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));

      seasonList[index].episodes = epList;

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void restoreEpisode(SeasonModel season, EpisodeModel episode) async {
    try {
      //
      final videoPath =
          MovieSeasonServices.getVideoPath(getCurrent!.id, episode);
      final videoFile = File(videoPath);
      if (await videoFile.exists()) {
        final newPath =
            '${PathUtil.instance.getOutPath()}/${episode.title}.${episode.ext}';
        await videoFile.rename(newPath);
      }

      final index = seasonList.indexWhere((se) => se.id == season.id);
      final epList =
          season.episodes.where((ep) => ep.id != episode.id).toList();
      seasonList[index].episodes = epList;

      //sort
      epList.sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));

      await MovieSeasonServices.instance
          .setList(getCurrent!.id, list: seasonList);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateEpisode(SeasonModel season, EpisodeModel episode) async {
    try {
      final index = seasonList.indexWhere((se) => se.id == season.id);
      final epList = season.episodes.map((ep) {
        if (ep.id == episode.id) {
          return episode;
        }
        return ep;
      }).toList();

      //sort
      epList.sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));

      seasonList[index].episodes = epList;

      await MovieSeasonServices.instance
          .setList(getCurrent!.id, list: seasonList);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }
}
