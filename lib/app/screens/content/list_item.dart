import 'package:flutter/material.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:t_widgets/widgets/index.dart';
import 'package:than_pkg/than_pkg.dart';

class ListItem extends StatelessWidget {
  VideoItem video;
  double height;
  void Function(VideoItem video) onClicked;
  void Function(VideoItem video)? onMenuClicked;
  ListItem({
    super.key,
    required this.video,
    required this.onClicked,
    this.onMenuClicked,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClicked(video),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          height: height,
          child: Column(
            spacing: 5,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: TImageFile(path: video.coverPath),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 5,
                  children: [
                    Expanded(
                      child: Column(
                        spacing: 3,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            video.date.toParseTime(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (onMenuClicked != null) {
                          onMenuClicked!(video);
                        }
                      },
                      icon: Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
