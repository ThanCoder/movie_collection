import 'package:flutter/material.dart';
import 'package:mc_v2/my_libs/setting/app_notifier.dart';
import 'package:t_widgets/t_widgets.dart';

class ThemeComponent extends StatelessWidget {
  const ThemeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final config = appConfigNotifier.value;
    return TListTileWithDesc(
      title: 'Dark Mode',
      trailing: Checkbox.adaptive(
        value: config.isDarkTheme,
        onChanged: (value) {
          config.isDarkTheme = value!;
          config.save();
        },
      ),
    );
  }
}
