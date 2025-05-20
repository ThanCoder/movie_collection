import 'package:flutter/material.dart';
import 'package:mc_v2/models/video_item.dart';
import 'package:mc_v2/notifiers/drop_notifier.dart';
import 'package:mc_v2/screens/content/content_screen.dart';

import 'screens/content/my_listener/page_navi_listener.dart';

void goContentScreen(BuildContext context, VideoItem video) {
  homeFileDropEnableNotifier.value = false;
  PageNaviSubject.instance.notiPageChanged();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ContentScreen(video: video),
    ),
  );
}

