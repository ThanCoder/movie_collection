import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:movie_collections/app/notifiers/app_notifier.dart';
import 'package:movie_collections/app/screens/index.dart';
import 'package:movie_collections/app/services/index.dart';
import 'package:movie_collections/app/widgets/index.dart';

class HomeMorePage extends StatelessWidget {
  const HomeMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //theme
            ListTileWithDesc(
              leading: Icon(Icons.dark_mode_outlined),
              trailing: ValueListenableBuilder(
                valueListenable: isDarkThemeNotifier,
                builder: (context, value, child) => Checkbox(
                  value: value,
                  onChanged: (value) {
                    isDarkThemeNotifier.value = value!;
                    final config = appConfigNotifier.value;
                    config.isDarkTheme = value;
                    setConfigFile(config);
                    CherryToast.success(
                      title: Text('Saved Theme'),
                      inheritThemeColors: true,
                    ).show(context);
                  },
                ),
              ),
              title: 'Theme',
              onClick: () {},
            ),

            //setting
            ListTileWithDesc(
              leading: Icon(Icons.settings),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              title: 'Setting',
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppSettingScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
