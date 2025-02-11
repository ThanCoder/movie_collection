import 'package:flutter/material.dart';
import 'package:movie_collections/app/enums/list_view_style.dart';
import 'package:movie_collections/app/models/video_file_model.dart';
import 'package:movie_collections/app/utils/app_util.dart';
import 'package:movie_collections/app/widgets/my_image_file.dart';

class VideoListView extends StatelessWidget {
  List<VideoFileModel> videoList;
  ListViewStyle listStyle;
  void Function(VideoFileModel video) onClick;
  void Function(VideoFileModel video)? onLongClick;
  ScrollController? controller;
  VideoListView({
    super.key,
    required this.videoList,
    required this.onClick,
    this.listStyle = ListViewStyle.list_view,
    this.onLongClick,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      itemBuilder: (context, index) {
        final video = videoList[index];
        return GestureDetector(
          onTap: () => onClick(video),
          onLongPress: () {
            if (onLongClick != null) {
              onLongClick!(video);
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              spacing: 10,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: MyImageFile(
                    path: video.coverPath,
                    borderRadius: 5,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(video.title),
                      Text(getParseFileSize(video.size.toDouble())),
                      Text(getParseDate(video.date)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: videoList.length,
    );
  }
}
