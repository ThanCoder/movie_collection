import 'package:flutter/material.dart';
import 'package:mc_v2/my_libs/general_server/current_version_component.dart';
import 'package:mc_v2/my_libs/setting/app_setting_screen.dart';
import 'package:mc_v2/my_libs/setting/theme_component.dart';
import 'package:t_widgets/widgets/index.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //theme
              ThemeComponent(),
              //version
              CurrentVersionComponent(),
              //setting
              TListTileWithDesc(
                leading: Icon(Icons.settings),
                title: 'Setting',
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppSettingScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
