import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:than_pkg/than_pkg.dart';

import 'list_item.dart';

class VideoRandomSliverList extends StatelessWidget {
  VideoItem? currentVideo;
  void Function(VideoItem video) onClicked;
  void Function(VideoItem video)? onMenuClicked;
  VideoRandomSliverList({
    super.key,
    required this.onClicked,
    this.currentVideo,
    this.onMenuClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: VideoItem.db.listenable(),
      builder: (context, db, child) {
        var randomList = List.of(db.values.toList());
        if (currentVideo != null) {
          randomList =
              randomList.where((e) => e.title != currentVideo!.title).toList();
        }
        randomList.shuffle();
        //for desktop
        if (PlatformExtension.isDesktop()) {
          return SliverGrid.builder(
            itemCount: randomList.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisExtent: 300,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) => ListItem(
              height: 300,
              video: randomList[index],
              onClicked: onClicked,
              onMenuClicked: onMenuClicked,
            ),
          );
        }
        return SliverList.builder(
          itemCount: randomList.length,
          itemBuilder: (context, index) => ListItem(
            height: 250,
            video: randomList[index],
            onClicked: onClicked,
            onMenuClicked: onMenuClicked,
          ),
        );
      },
    );
  }
}
