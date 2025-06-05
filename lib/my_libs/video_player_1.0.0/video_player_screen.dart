import 'package:flutter/material.dart';
import 'package:mc_v2/my_libs/video_player_1.0.0/video_file_model.dart';
import 'package:mc_v2/my_libs/video_player_1.0.0/video_player.dart';

class VideoPlayerScreen extends StatelessWidget {
  VideoFileModel videoFile;
  VideoPlayerScreen({
    super.key,
    required this.videoFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(videoFile.title),
      ),
      body: VideoPlayer(videoFile: videoFile),
    );
  }
}
