import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:movie_collections/app/constants.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:provider/provider.dart';
import 'package:than_pkg/than_pkg.dart';

import '../models/index.dart';
import '../notifiers/app_notifier.dart';
import '../services/index.dart';
import '../widgets/index.dart';

class AppSettingScreen extends StatefulWidget {
  const AppSettingScreen({super.key});

  @override
  State<AppSettingScreen> createState() => _AppSettingScreenState();
}

class _AppSettingScreenState extends State<AppSettingScreen> {
  late AppConfigModel config;
  final TextEditingController customPathController = TextEditingController();

  @override
  void initState() {
    config = appConfigNotifier.value;
    super.initState();
    init();
  }

  void init() {
    if (config.customPath.isEmpty) {
      customPathController.text = '${appExternalPathNotifier.value}/.$appName';
    } else {
      customPathController.text = config.customPath;
    }
  }

  void _save() async {
    //check permission
    if (config.isUseCustomPath) {
      final isGranted = await ThanPkg.platform.isStoragePermissionGranted();
      if (!isGranted) {
        await ThanPkg.platform.requestStoragePermission();
        return;
      }
    }
    config.customPath = customPathController.text;
    setConfigFile(config);
    await initAppConfigService();
    //provider

    if (!mounted) return;

    await context.read<MovieProvider>().initList();

    if (!mounted) return;

    CherryToast.success(
      title: Text('Setting Saved'),
      inheritThemeColors: true,
    ).show(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Setting'),
        actions: [
          IconButton(
            onPressed: _save,
            icon: Icon(Icons.save_as_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //custom path
            ListTileWithDesc(
              title: 'Custom Path',
              desc: 'ကြိုက်နှစ်သက်ရာ path',
              trailing: Checkbox(
                value: config.isUseCustomPath,
                onChanged: (value) {
                  setState(() {
                    config.isUseCustomPath = value!;
                  });
                },
              ),
            ),
            //custom path
            config.isUseCustomPath
                ? Card(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TTextField(
                      hintText: 'Custom Path',
                      label: Text('Custom Path'),
                      controller: customPathController,
                    ),
                  ))
                : Container()
          ],
        ),
      ),
    );
  }
}
