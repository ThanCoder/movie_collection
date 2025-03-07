import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/utils/index.dart';

Future<void> changeHiveDatabasePath() async {
  try {
    String path = PathUtil.instance.getDatabasePath();
    if (Hive.isBoxOpen(MovieModel.getName)) {
      await Hive.box<MovieModel>(MovieModel.getName).close();
    }
    //close hive
    await Hive.close();
    await Future.delayed(Duration(milliseconds: 1200));

    //open
    Hive.init(path);

    if (!Hive.isAdapterRegistered(MovieModelAdapter().typeId)) {
      Hive.registerAdapter(MovieModelAdapter());
    }

    //open box
    await Hive.openBox<MovieModel>(MovieModel.getName);

    debugPrint('database path Changed: $path');
  } catch (e) {
    debugPrint('initDBPath: ${e.toString()}');
  }
}
