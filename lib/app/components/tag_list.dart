import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/tag_model.dart';
import 'package:movie_collections/app/routes_helper.dart';
import 'package:movie_collections/app/services/tag_services.dart';

class TagList extends StatefulWidget {
  int maxCount;
  TagList({
    super.key,
    this.maxCount = 20,
  });

  @override
  State<TagList> createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  List<TagModel> list = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    list = await TagServices.instance.getList();
    // list.addAll(await TagServices.instance.getList());
    // list.addAll(await TagServices.instance.getList());
    // list.addAll(await TagServices.instance.getList());
    // list.addAll(await TagServices.instance.getList());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: List.generate(
        list.length,
        (index) {
          final tag = list[index];
          return GestureDetector(
            onTap: () {
              final list = TagServices.instance.getMovieList(tag.name);
              goResultScreen(context, title: '#${tag.name}', list: list);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.all(5),
                child: Text(
                  '#${tag.name}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
