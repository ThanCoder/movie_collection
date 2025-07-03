import 'package:flutter/material.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/models/video_type.dart';
import 'package:mc_v2/app/notifiers/drop_notifier.dart';
import 'package:mc_v2/app/screens/content/content_screen.dart';
import 'package:mc_v2/app/screens/content/my_listener/content_screen_event_listener.dart';
import 'package:mc_v2/app/screens/form/series_form_screen.dart';
import 'package:mc_v2/app/screens/form/video_form_screen.dart';
import 'package:mc_v2/app/screens/movie_result_screen.dart';
import 'package:mc_v2/my_libs/video_player_1.0.0/video_file_model.dart';
import 'package:mc_v2/my_libs/video_player_1.0.0/video_player_screen.dart';

void goVideoPlayerScreen(
  BuildContext context, {
  required VideoFileModel videoFile,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoFile: videoFile)),
  );
}

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

void goResultScreen(BuildContext context, String title, List<VideoItem> list) {
  // homeFileDropEnableNotifier.value = false;
  resultVideoListNotifier.value = list;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MovieResultScreen(title: title),
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
