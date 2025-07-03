import 'package:flutter/material.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/models/video_type.dart';
import 'package:t_widgets/widgets/index.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:than_pkg/types/src_dist_type.dart';

class VideoGridItem extends StatefulWidget {
  VideoItem video;
  void Function(VideoItem video) onClicked;
  VideoGridItem({
    super.key,
    required this.video,
    required this.onClicked,
  });

  @override
  State<VideoGridItem> createState() => _VideoGridItemState();
}

class _VideoGridItemState extends State<VideoGridItem> {
  @override
  void initState() {
    super.initState();
    init();
  }

  bool isLoading = false;

  Future<void> init() async {
    setState(() {
      isLoading = true;
    });
    await ThanPkg.platform.genVideoThumbnail(pathList: [
      SrcDistType(
        src: widget.video.filePath,
        dist: widget.video.coverPath,
      ),
    ]);

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    if (isLoading) return TLoader();
    return GestureDetector(
      onTap: () => widget.onClicked(widget.video),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          children: [
            Positioned.fill(
              child: TImageFile(path: widget.video.coverPath),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(148, 32, 32, 32),
                ),
                child: Text(
                  widget.video.title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            video.isExists || video.type == VideoType.series
                ? SizedBox.shrink()
                : Positioned(
                    right: 0,
                    child: Container(
                      color: const Color.fromARGB(155, 29, 29, 29),
                      child: Icon(
                        color: Colors.red,
                        Icons.error_outline_rounded,
                      ),
                    ),
                  ),
            Positioned(
              child: Icon(
                  color: const Color.fromARGB(255, 37, 175, 9),
                  video.type == VideoType.series ? Icons.tv : Icons.movie),
            )
          ],
        ),
      ),
    );
  }
}
