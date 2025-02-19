import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:movie_collections/app/models/genres_model.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/models/video_file_model.dart';
import 'package:movie_collections/app/my_app.dart';
import 'package:movie_collections/app/notifiers/app_notifier.dart';
import 'package:movie_collections/app/providers/genres_provider.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/providers/video_provider.dart';
import 'package:movie_collections/app/services/app_config_services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //init config
  await initAppConfigService();

  await Hive.initFlutter(appRootPathNotifier.value);
  //adapter
  Hive.registerAdapter(MovieModelAdapter());
  Hive.registerAdapter(VideoFileModelAdapter());
  Hive.registerAdapter(GenresModelAdapter());
  //open box
  await Hive.openBox<MovieModel>(MovieProvider.boxName);
  await Hive.openBox<VideoFileModel>(VideoProvider.boxName);
  await Hive.openBox<GenresModel>(GenresProvider.boxName);
  //media player
  MediaKit.ensureInitialized();
  // //default dark mode
  // isDarkThemeNotifier.value = true;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MovieProvider()),
        ChangeNotifierProvider(create: (context) => VideoProvider()),
        ChangeNotifierProvider(create: (context) => GenresProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
