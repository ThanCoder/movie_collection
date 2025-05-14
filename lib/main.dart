import 'package:flutter/material.dart';
import 'package:mc_v2/my_libs/setting/app_config_services.dart';

import 'my_app.dart';

void main() async {
  await initAppConfigService();
  runApp(const MyApp());
}
