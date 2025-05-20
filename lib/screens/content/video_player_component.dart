import 'package:flutter/material.dart';
import 'package:mc_v2/models/video_item.dart';
import 'package:mc_v2/screens/content/platforms_media_quary.dart';
import 'package:mc_v2/screens/content/video_player.dart';
import 'package:t_widgets/widgets/index.dart';

class VideoPlayerComponent extends StatefulWidget {
  VideoItem video;
  VideoPlayerComponent({
    super.key,
    required this.video,
  });

  @override
  State<VideoPlayerComponent> createState() => _VideoPlayerComponentState();
}

class _VideoPlayerComponentState extends State<VideoPlayerComponent> {
  bool isShowVideoPlayer = false;

  Widget _getPlayer() {
    return VideoPlayer(video: widget.video);
  }

  Widget _header() {
    return TImageFile(path: widget.video.coverPath);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isShowVideoPlayer = true;
        setState(() {});
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          height: PlatformsMediaQuary.getPlayerHeight,
          child: isShowVideoPlayer ? _getPlayer() : _header(),
        ),
      ),
    );
  }
}
