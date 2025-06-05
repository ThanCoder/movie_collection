import 'package:flutter/material.dart';
import 'package:mc_v2/my_libs/general_server_v1.0.0/current_version_component.dart';
import 'package:mc_v2/my_libs/setting/app_setting_screen.dart';
import 'package:mc_v2/my_libs/setting/theme_component.dart';
import 'package:mc_v2/app/screens/home/delete_action.dart';
import 'package:t_widgets/widgets/index.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //theme
              ThemeComponent(),
              //version
              CurrentVersionComponent(),
              const Divider(),
              // delete
              DeleteAction(),

              const Divider(),
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
