import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/video_grid_view.dart';
import 'package:movie_collections/app/components/video_list_view.dart';
import 'package:movie_collections/app/enums/list_view_style.dart';
import 'package:movie_collections/app/models/video_file_model.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/video_provider.dart';
import 'package:movie_collections/app/widgets/t_loader.dart';
import 'package:provider/provider.dart';

class VideoListPage extends StatefulWidget {
  void Function(VideoFileModel video) onClick;
  VideoListPage({super.key, required this.onClick});

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    init();
  }

  ListViewStyle listViewStyle = ListViewStyle.list_view;

  void init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<VideoProvider>()
          .initList(movieId: currentMovieNotifier.value!.id);
    });
  }

  void _toggleListStyle() {
    if (listViewStyle == ListViewStyle.list_view) {
      setState(() {
        listViewStyle = ListViewStyle.grid_view;
      });
    } else {
      setState(() {
        listViewStyle = ListViewStyle.list_view;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VideoProvider>();
    final videoList = provider.getList;
    final isLoading = provider.isLoading;
    if (isLoading) {
      return Center(child: TLoader());
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          //header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: _toggleListStyle,
                  icon: Icon(listViewStyle == ListViewStyle.grid_view
                      ? Icons.grid_view
                      : Icons.list),
                ),
              ],
            ),
          ),
          Expanded(
            child: listViewStyle == ListViewStyle.list_view
                ? VideoListView(
                    controller: scrollController,
                    videoList: videoList,
                    onClick: widget.onClick,
                  )
                : VideoGridView(
                    videoList: videoList,
                    onClick: widget.onClick,
                  ),
          ),
        ],
      ),
    );
  }
}
