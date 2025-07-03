import 'package:flutter/material.dart';
import 'package:mc_v2/app/components/video_grid_item.dart';
import 'package:mc_v2/app/models/video_item.dart';

class SeeAllView extends StatelessWidget {
  List<VideoItem> list;
  String title;
  int showCount;
  int? showLines;
  double fontSize;
  void Function(String title, List<VideoItem> list) onSeeAllClicked;
  void Function(VideoItem video) onClicked;
  EdgeInsetsGeometry? margin;
  double padding;

  SeeAllView({
    super.key,
    required this.title,
    required this.list,
    required this.onSeeAllClicked,
    required this.onClicked,
    this.showCount = 10,
    this.margin,
    this.showLines,
    this.fontSize = 11,
    this.padding = 6,
  });

  @override
  Widget build(BuildContext context) {
    // print('${list.length} > $showCount');

    final showList = list.take(showCount).toList();
    if (showList.isEmpty) return const SizedBox.shrink();
    var lines = 1;
    if (showLines == null && showList.length > 2) {
      lines = 2;
    } else {
      lines = showLines ?? 1;
    }

    return Container(
      padding: EdgeInsets.all(padding),
      margin: margin,
      child: SizedBox(
        height: lines * 160,
        child: Column(
          spacing: 5,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                list.length > showCount
                    ? GestureDetector(
                        onTap: () => onSeeAllClicked(title, list),
                        child: const MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            'See All',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            Expanded(
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: showList.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 170,
                  mainAxisExtent: 130,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemBuilder: (context, index) => VideoGridItem(
                  video: showList[index],
                  onClicked: onClicked,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
