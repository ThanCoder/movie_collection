import 'package:flutter/material.dart';
import 'package:mc_v2/my_libs/setting/app_notifier.dart';

import 'screens/home/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: appConfigNotifier,
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark(),
            theme: value.isDarkTheme ? ThemeData.dark() : null,
            home: HomeScreen(),
          );
        });
  }
}
