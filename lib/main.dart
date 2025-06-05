import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mc_v2/app/models/episode.dart';
import 'package:mc_v2/app/models/info_type.dart';
import 'package:mc_v2/app/models/season.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/models/video_type.dart';
import 'package:mc_v2/my_libs/setting/app_config_services.dart';
import 'package:mc_v2/my_libs/setting/app_notifier.dart';
import 'package:mc_v2/my_libs/setting/path_util.dart';
import 'package:media_kit/media_kit.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

import 'app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initAppConfigService();

  await ThanPkg.instance.init();

  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/logo.png',
    getDarkMode: () {
      return appConfigNotifier.value.isDarkTheme;
    },
  );
  // hive
  await Hive.initFlutter(PathUtil.getDatabasePath());
  // adapter
  Hive.registerAdapter<VideoItem>(VideoItemAdapter());
  Hive.registerAdapter(VideoTypeAdapter());
  Hive.registerAdapter(InfoTypeAdapter());
  Hive.registerAdapter(SeasonAdapter());
  Hive.registerAdapter(EpisodeAdapter());

  await Hive.openBox<VideoItem>(VideoItem.dbName);

  MediaKit.ensureInitialized();

  PathUtil.getDatabaseSourcePath();

  runApp(const MyApp());
}
