import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mc_v2/app/components/see_all_view.dart';
import 'package:mc_v2/app/components/video_grid_item.dart';
import 'package:mc_v2/app/constants.dart';
import 'package:mc_v2/app/models/video_type.dart';
import 'package:mc_v2/app/screens/home/add_video_dialog.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/notifiers/drop_notifier.dart';
import 'package:mc_v2/app/route_helper.dart';
import 'package:mc_v2/app/screens/home/add_action_button.dart';
import 'package:mc_v2/app/screens/home/search_screen.dart';
import 'package:mc_v2/my_libs/setting/app_notifier.dart';
import 'package:mc_v2/my_libs/setting/home_list_style.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/extensions/platform_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  Future<void> init() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  void _addPath(List<String> pathList) {
    if (pathList.isEmpty) return;
    List<VideoItem> list = [];
    for (var path in pathList) {
      list.add(VideoItem.fromPath(path));
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddVideoDialog(
        list: list,
        onRefersh: () {
          setState(() {});
        },
      ),
    );
  }

  Widget _showGroupListStyle(List<VideoItem> list) {
    final movieList = list.where((e) => e.type == VideoType.movie).toList();
    final musicList = list.where((e) => e.type == VideoType.music).toList();
    final seriesList = list.where((e) => e.type == VideoType.series).toList();
    final pornList = list.where((e) => e.type == VideoType.porn).toList();
    final randomList = List.of(list);
    randomList.shuffle();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SeeAllView(
            title: 'Random',
            list: randomList,
            showLines: 1,
            onSeeAllClicked: (title, list) =>
                goResultScreen(context, title, list),
            onClicked: (video) => goContentScreen(context, video),
          ),
        ),
        SliverToBoxAdapter(
          child: SeeAllView(
            title: 'Latest',
            list: list,
            onSeeAllClicked: (title, list) =>
                goResultScreen(context, title, list),
            onClicked: (video) => goContentScreen(context, video),
          ),
        ),
        SliverToBoxAdapter(
          child: SeeAllView(
            title: 'Movie',
            list: movieList,
            onSeeAllClicked: (title, list) =>
                goResultScreen(context, title, list),
            onClicked: (video) => goContentScreen(context, video),
          ),
        ),
        SliverToBoxAdapter(
          child: SeeAllView(
            title: 'Music',
            list: musicList,
            onSeeAllClicked: (title, list) =>
                goResultScreen(context, title, list),
            onClicked: (video) => goContentScreen(context, video),
          ),
        ),
        SliverToBoxAdapter(
          child: SeeAllView(
            title: 'TV Series',
            list: seriesList,
            onSeeAllClicked: (title, list) =>
                goResultScreen(context, title, list),
            onClicked: (video) => goContentScreen(context, video),
          ),
        ),
        SliverToBoxAdapter(
          child: SeeAllView(
            title: 'Porns',
            list: pornList,
            onSeeAllClicked: (title, list) =>
                goResultScreen(context, title, list),
            onClicked: (video) => goContentScreen(context, video),
          ),
        ),
      ],
    );
  }

  Widget _showAllListStyle(List<VideoItem> list) {
    return GridView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => VideoGridItem(
        video: list[index],
        onClicked: (video) {
          goContentScreen(context, video);
        },
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 180,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          // search
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
          PlatformExtension.isDesktop()
              ? IconButton(
                  onPressed: init,
                  icon: Icon(Icons.refresh),
                )
              : const SizedBox.shrink(),
          AddActionButton(),
        ],
      ),
      body: isLoading
          ? TLoader()
          : ValueListenableBuilder(
              valueListenable: homeFileDropEnableNotifier,
              builder: (context, dropEnalbe, child) {
                return DropTarget(
                  enable: dropEnalbe,
                  onDragDone: (details) {
                    _addPath(details.files.map((e) => e.path).toList());
                  },
                  child: ValueListenableBuilder(
                    valueListenable: VideoItem.db.listenable(),
                    builder: (context, db, child) {
                      final list = VideoItem.getLatest();
                      if (list.isEmpty) {
                        return Center(
                          child: Text(PlatformExtension.isDesktop()
                              ? 'Drop Here...'
                              : 'List Empty...'),
                        );
                      }
                      final homeStyle = appConfigNotifier.value.homeListStyle;
                      if (homeStyle == HomeListStyle.groupListStyle) {
                        return RefreshIndicator.adaptive(
                          onRefresh: init,
                          child: _showGroupListStyle(list),
                        );
                      }
                      return RefreshIndicator.adaptive(
                        onRefresh: init,
                        child: _showAllListStyle(list),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
