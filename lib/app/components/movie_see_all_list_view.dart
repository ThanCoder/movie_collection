import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/widgets/core/index.dart';

class MovieSeeAllListView extends StatelessWidget {
  List<MovieModel> list;
  String title;
  void Function(MovieModel movie) onClicked;
  void Function() onSeeAllClicked;
  int limit;
  double width;
  double height;
  double fontSize;
  MovieSeeAllListView({
    super.key,
    required this.title,
    required this.list,
    required this.onClicked,
    required this.onSeeAllClicked,
    this.limit = 5,
    this.width = 150,
    this.height = 160,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              TextButton(onPressed: onSeeAllClicked, child: Text('See All')),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(list.take(5).length, (index) {
              final movie = list[index];
              return GestureDetector(
                onTap: () => onClicked(movie),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: width,
                          height: height,
                          child: MyImageFile(
                            path: movie.coverPath,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(155, 0, 0, 0),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            child: Text(
                              movie.title,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
