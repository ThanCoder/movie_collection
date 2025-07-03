import 'package:flutter/material.dart';
import 'package:mc_v2/app/components/video_grid_item.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/route_helper.dart';
import 'package:than_pkg/extensions/platform_extension.dart';

ValueNotifier<List<VideoItem>> resultVideoListNotifier = ValueNotifier([]);

class MovieResultScreen extends StatelessWidget {
  String title;
  MovieResultScreen({
    super.key,
    required this.title,
  });

  Future<void> _refresh() async {
    if (title == 'Random') {
      final random = List.of(resultVideoListNotifier.value);
      random.shuffle();
      resultVideoListNotifier.value = random;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          PlatformExtension.isDesktop()
              ? IconButton(
                  onPressed: _refresh,
                  icon: Icon(Icons.refresh),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: resultVideoListNotifier,
        builder: (context, list, child) {
          return RefreshIndicator.adaptive(
            onRefresh: _refresh,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisExtent: 180,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) => VideoGridItem(
                video: list[index],
                onClicked: (video) {
                  goContentScreen(context, video);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
