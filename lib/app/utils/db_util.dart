import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/utils/index.dart';

Future<void> changeHiveDatabasePath() async {
  try {
    //close hive
    await Hive.close();
    //open
    await Hive.initFlutter(PathUtil.instance.getDatabasePath());

    await Hive.openBox(MovieModel.getName);
  } catch (e) {
    debugPrint('initDBPath: ${e.toString()}');
  }
}
