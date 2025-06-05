import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/extensions/index.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/widgets/core/index.dart';

import '../utils/index.dart';

class MovieListItem extends StatefulWidget {
  MovieModel movie;
  void Function(MovieModel movie, double itemHeight) onClicked;
  void Function(MovieModel movie)? onLongClicked;
  void Function(MovieModel movie)? onMenuClicked;
  bool isActiveColor;
  int currentIndex;
  int activeIndex;
  double size;
  MovieListItem({
    super.key,
    required this.movie,
    required this.onClicked,
    this.onMenuClicked,
    this.onLongClicked,
    this.isActiveColor = false,
    this.currentIndex = 0,
    this.activeIndex = 0,
    this.size = 130,
  });

  @override
  State<MovieListItem> createState() => _MovieListItemState();
}

class _MovieListItemState extends State<MovieListItem> {
  final GlobalKey _key = GlobalKey();
  double itemHeight = 0;

  @override
  void initState() {
    super.initState();
    _getItemHeightInit();
  }

  void _getItemHeightInit() {
    // **Get item height after layout**
    Future.microtask(() {
      final RenderBox? box =
          _key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        setState(() {
          itemHeight = box.size.height;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: () => widget.onClicked(widget.movie, itemHeight),
      onLongPress: () {
        if (widget.onLongClicked != null) {
          widget.onLongClicked!(widget.movie);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Card(
          child: AnimatedContainer(
            padding: EdgeInsets.all(2),
            duration: Duration(milliseconds: 400),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: widget.isActiveColor
                    ? widget.currentIndex == widget.activeIndex
                        ? const Color.fromARGB(141, 24, 163, 149)
                        : null
                    : null),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: MyImageFile(path: widget.movie.coverPath),
                ),
                Expanded(
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie.title,
                        maxLines: 2,
                        style: TextStyle(fontSize: 12),
                      ),
                      //type
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 5,
                          children: [
                            Text('Type: '),
                            Text(widget.movie.type.toCaptalize()),
                            SizedBox(width: 10),
                            Text('InfoType: '),
                            Text(widget.movie.infoType.toCaptalize()),
                          ],
                        ),
                      ),

                      // Text(widget.movie.tags),
                      Text(AppUtil.instance
                          .getParseFileSize(widget.movie.size.toDouble())),

                      Text(AppUtil.instance.getParseDate(widget.movie.date)),
                      MovieBookmarkButton(movie: widget.movie),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (widget.onMenuClicked != null) {
                      widget.onMenuClicked!(widget.movie);
                    }
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
