import 'package:flutter/material.dart';
import 'package:mc_v2/models/video_item.dart';
import 'package:mc_v2/models/video_type.dart';
import 'package:mc_v2/notifiers/drop_notifier.dart';
import 'package:mc_v2/screens/content/content_screen.dart';
import 'package:mc_v2/screens/content/my_listener/content_screen_event_listener.dart';
import 'package:mc_v2/screens/form/series_form_screen.dart';
import 'package:mc_v2/screens/form/video_form_screen.dart';

void goContentScreen(BuildContext context, VideoItem video) {
  homeFileDropEnableNotifier.value = false;
  ContentScreenEventSender.instance.pageChanged();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ContentScreen(video: video),
    ),
  );
}

void goFormScreen(BuildContext context, VideoItem video) {
  homeFileDropEnableNotifier.value = false;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => video.type == VideoType.series
          ? SeriesFormScreen(video: video)
          : VideoFormScreen(video: video),
    ),
  );
}
