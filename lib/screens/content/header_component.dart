import 'package:flutter/material.dart';
import 'package:mc_v2/models/video_item.dart';
import 'package:mc_v2/widgets/t_list_icon.dart';

class HeaderComponent extends StatelessWidget {
  VideoItem video;
  void Function()? onMenuOpen;
  HeaderComponent({
    super.key,
    required this.video,
    this.onMenuOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TListIcon(
                      icon: Icon(Icons.title_rounded),
                      title: Text(video.title)),
                  TListIcon(
                      icon: Icon(Icons.camera_front_outlined),
                      title: Text(video.mime)),
                  TListIcon(
                      icon: Icon(Icons.info_outline_rounded),
                      title: Text(video.infoType.name)),
                  TListIcon(
                      icon: Icon(Icons.type_specimen_rounded),
                      title: Text(video.type.name)),
                  TListIcon(
                      icon: Icon(Icons.file_present),
                      title: Text(video.getSizeLable)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                if (onMenuOpen != null) {
                  onMenuOpen!();
                }
              },
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
