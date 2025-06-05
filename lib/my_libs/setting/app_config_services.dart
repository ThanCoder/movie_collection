import 'package:flutter/material.dart';
import 'package:than_pkg/than_pkg.dart';
import '../../app/constants.dart';
import 'app_config_model.dart';
import 'app_notifier.dart';

Future<void> initAppConfigService() async {
  try {
    final rootPath = await ThanPkg.platform.getAppRootPath();
    final externalPath = await ThanPkg.platform.getAppExternalPath();
    //set
    if (rootPath != null) {
      appRootPathNotifier.value = '$rootPath/.$appName';
      appConfigPathNotifier.value = '$rootPath/.$appName';
    }
    if (externalPath != null) {
      appExternalPathNotifier.value = externalPath;
    }
    await _initAppConfig();
  } catch (e) {
    debugPrint('initConfig: ${e.toString()}');
  }
}

Future<void> _initAppConfig() async {
  try {
    final config = AppConfigModel.get();
    appConfigNotifier.value = config;
    //custom path
    if (config.isUseCustomPath && config.customPath.isNotEmpty) {
      appRootPathNotifier.value = config.customPath;
    }
    isDarkThemeNotifier.value = config.isDarkTheme;
  } catch (e) {
    debugPrint('_initAppConfig: ${e.toString()}');
  }
}
