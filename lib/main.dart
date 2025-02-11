import 'dart:io';

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
import 'package:movie_collections/app/services/app_path_services.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //url
  // const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  // const supabaseKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  // await Supabase.initialize(
  //   url: supabaseUrl,
  //   anonKey: supabaseKey,
  // );
  //init config
  await initConfig();

  await Hive.initFlutter(getAppRootPath());
  //adapter
  Hive.registerAdapter(MovieModelAdapter());
  Hive.registerAdapter(VideoFileModelAdapter());
  Hive.registerAdapter(GenresModelAdapter());
  //open box
  await Hive.openBox<MovieModel>(MovieProvider.boxName);
  await Hive.openBox<VideoFileModel>(VideoProvider.boxName);
  await Hive.openBox<GenresModel>(GenresProvider.boxName);

  if (Platform.isLinux) {
    await WindowManager.instance.ensureInitialized();
  }
  //media player
  MediaKit.ensureInitialized();
  //default dark mode
  isDarkThemeNotifier.value = true;

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
