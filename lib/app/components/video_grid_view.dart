import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/video_file_model.dart';
import 'package:movie_collections/app/widgets/my_image_file.dart';

class VideoGridView extends StatelessWidget {
  List<VideoFileModel> videoList;
  void Function(VideoFileModel video) onClick;
  VideoGridView({super.key, required this.videoList, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: videoList.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        crossAxisSpacing: 5,
        maxCrossAxisExtent: 200,
        mainAxisExtent: 240,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        final video = videoList[index];
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onClick(video),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: MyImageFile(
                              path: video.coverPath,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Text(
                          video.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
