import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/providers/series_video_player_provider.dart';
import 'package:movie_collections/app/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:than_pkg/than_pkg.dart';

import 'app/my_app.dart';
import 'app/services/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThanPkg.windowManagerensureInitialized();

  //init config
  await initAppConfigService();
  //mdia
  MediaKit.ensureInitialized();

  //hive
  await Hive.initFlutter(PathUtil.instance.getDatabasePath());
  //adapter
  Hive.registerAdapter(MovieModelAdapter());
  //open box
  await Hive.openBox<MovieModel>(MovieModel.getName);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MovieProvider()),
        ChangeNotifierProvider(
            create: (context) => SeriesVideoPlayerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
