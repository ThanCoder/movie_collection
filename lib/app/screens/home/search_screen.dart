import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mc_v2/app/components/video_grid_item.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/route_helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  List<VideoItem> list = [];

  void _search(String text) {
    if (text.isEmpty) {
      list = [];
      setState(() {});
      return;
    }
    final result = VideoItem.db.values.where((e) {
      if (e.title.toUpperCase().contains(text.toUpperCase())) {
        return true;
      }
      if (e.description.contains(text)) return true;
      return false;
    }).toList();
    // sort
    list.sort((a, b) => a.title.compareTo(b.title));

    list = result;
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: CupertinoSearchTextField(
              controller: searchController,
              autofocus: true,
              onChanged: _search,
            ),
          ),
          SliverGrid.builder(
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
        ],
      ),
    );
  }
}
