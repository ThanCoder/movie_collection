import 'package:flutter/material.dart';
import 'package:mc_v2/my_libs/setting/app_notifier.dart';

import 'screens/home/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: appConfigNotifier,
        builder: (context, config, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: config.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            home: HomeScreen(),
          );
        });
  }
}
