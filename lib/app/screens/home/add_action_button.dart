import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mc_v2/app/screens/home/add_video_dialog.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/platforms/platform_libs.dart';
import 'package:mc_v2/app/route_helper.dart';
import 'package:t_widgets/t_widgets.dart';

class AddActionButton extends StatefulWidget {
  const AddActionButton({super.key});

  @override
  State<AddActionButton> createState() => _AddActionButtonState();
}

class _AddActionButtonState extends State<AddActionButton> {
  void _addFromSelector() async {
    final res = await PlatformLibs.videoPathChooser(context);
    if (res.isEmpty) return;

    final list = res.map((e) => VideoItem.fromPath(e)).toList();
    if (!mounted) return;
    showCupertinoDialog(
      context: context,
      builder: (context) => AddVideoDialog(list: list),
    );
  }

  void _addFromPath() {
    showDialog(
      context: context,
      builder: (ctx) => TRenameDialog(
        text: '',
        onSubmit: (path) async {
          final res = await PlatformLibs.videoDirPathChooser(path);
          if (res.isEmpty) return;

          final list = res.map((e) => VideoItem.fromPath(e)).toList();
          if (!ctx.mounted) return;
          showCupertinoDialog(
            context: ctx,
            builder: (context) => AddVideoDialog(list: list),
          );
        },
      ),
    );
  }

  void _addSeries() {
    showDialog(
      context: context,
      builder: (ctx) => TRenameDialog(
        text: 'Untitled',
        onCheckIsError: (text) {
          final res = VideoItem.isExistsTitle(text);
          if (res) {
            return 'ရှိနေပါတယ် - title ပြောင်းပေးပါ!';
          }
          return null;
        },
        submitText: 'New Series',
        onSubmit: (title) async {
          final series = VideoItem.createSeries(title);
          await series.add();
          if (!ctx.mounted) return;
          goFormScreen(ctx, series);
        },
      ),
    );
  }

  void _menu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 150),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Series'),
                onTap: () {
                  Navigator.pop(context);
                  _addSeries();
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Movie Selector'),
                onTap: () {
                  Navigator.pop(context);
                  _addFromSelector();
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Movie Path'),
                onTap: () {
                  Navigator.pop(context);
                  _addFromPath();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _menu,
      icon: Icon(Icons.more_vert),
    );
  }
}
