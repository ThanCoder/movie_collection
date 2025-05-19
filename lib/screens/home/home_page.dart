import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mc_v2/components/video_grid_item.dart';
import 'package:mc_v2/constants.dart';
import 'package:mc_v2/dialogs/add_video_dialog.dart';
import 'package:mc_v2/models/video_item.dart';
import 'package:mc_v2/notifiers/drop_notifier.dart';
import 'package:mc_v2/route_helper.dart';
import 'package:than_pkg/extensions/platform_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _addPath(List<String> pathList) {
    if (pathList.isEmpty) return;
    List<VideoItem> list = [];
    for (var path in pathList) {
      list.add(VideoItem.fromPath(path));
    }
    showDialog(
      context: context,
      builder: (context) => AddVideoDialog(list: list),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: ValueListenableBuilder(
          valueListenable: homeFileDropEnableNotifier,
          builder: (context, dropEnalbe, child) {
            return DropTarget(
              enable: dropEnalbe,
              onDragDone: (details) {
                _addPath(details.files.map((e) => e.path).toList());
              },
              child: ValueListenableBuilder(
                valueListenable: VideoItem.db.listenable(),
                builder: (context, db, child) {
                  final list = VideoItem.getLatest();
                  if (list.isEmpty) {
                    return Center(
                      child: Text(PlatformExtension.isDesktop()
                          ? 'Drop Here...'
                          : 'List Empty...'),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisExtent: 180,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) => VideoGridItem(
                      video: list[index],
                      onClicked: (video) {
                        goContentScreen(context, video);
                      },
                    ),
                  );
                },
              ),
            );
          },
        ));
  }
}
