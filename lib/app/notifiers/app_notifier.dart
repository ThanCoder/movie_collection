import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/app_config_model.dart';

ValueNotifier<String> appRootPathNotifier = ValueNotifier('');
ValueNotifier<String> appDataRootPathNotifier = ValueNotifier('');
ValueNotifier<String> appConfigPathNotifier = ValueNotifier('');
ValueNotifier<bool> isDarkThemeNotifier = ValueNotifier(false);
//config
ValueNotifier<AppConfigModel> appConfigNotifier =
    ValueNotifier(AppConfigModel());
