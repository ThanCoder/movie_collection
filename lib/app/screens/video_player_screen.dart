import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_collections/app/components/app_components.dart';
import 'package:movie_collections/app/models/video_file_model.dart';
import 'package:movie_collections/app/widgets/my_scaffold.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoFileModel video;
  bool isAutoPlay;
  VideoPlayerScreen({
    super.key,
    required this.video,
    this.isAutoPlay = false,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late final Player player = Player();
  late final VideoController _controller = VideoController(player);

  int allSeconds = 0;
  int progressSeconds = 0;

  void init() {
    try {
      player.open(Media(widget.video.path));
    } catch (e) {
      showDialogMessage(context, e.toString());
    }
  }

  // String _formatDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, "0");
  //   String minutes = twoDigits(duration.inMinutes.remainder(60));
  //   String seconds = twoDigits(duration.inSeconds.remainder(60));
  //   return "$minutes:$seconds";
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await player.playOrPause();
        await player.dispose();
        return true;
      },
      child: MyScaffold(
        contentPadding: 0,
        appBar: AppBar(
          title: Text(widget.video.title),
        ),
        body: Center(
          child: AspectRatio(
            aspectRatio: player.state.videoParams.aspect ?? 16 / 9,
            child: Video(
              controller: _controller,
            ),
          ),
        ),
      ),
    );
  }
}
