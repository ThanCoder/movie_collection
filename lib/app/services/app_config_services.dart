import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_collections/app/constants.dart';
import 'package:movie_collections/app/models/app_config_model.dart';
import 'package:movie_collections/app/notifiers/app_notifier.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initConfig() async {
  try {
    if (Platform.isLinux) {
      appRootPathNotifier.value = '${Directory.current.path}/.$appName';
    } else if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      appRootPathNotifier.value = dir!.path;
      appDataRootPathNotifier.value = dir.path;
    }
    appConfigPathNotifier.value =
        '${appRootPathNotifier.value}/$appConfigFileName';
    //config
    await initAppConfig();
  } catch (e) {
    debugPrint('initConfig: ${e.toString()}');
  }
}

Future<void> initAppConfig() async {
  final config = getConfigFile();
  appConfigNotifier.value = config;
  //custom path
  if (config.isUseCustomPath && config.customPath.isNotEmpty) {
    appRootPathNotifier.value = config.customPath;
  }
  isDarkThemeNotifier.value = config.isDarkTheme;
}

AppConfigModel getConfigFile() {
  final file = File(appConfigPathNotifier.value);
  if (!file.existsSync()) {
    return AppConfigModel();
  }
  return AppConfigModel.fromJson(jsonDecode(file.readAsStringSync()));
}

void setConfigFile(AppConfigModel appConfig) {
  final file = File(appConfigPathNotifier.value);
  String data = const JsonEncoder.withIndent('  ').convert(appConfig.toJson());
  file.writeAsStringSync(data);
}
