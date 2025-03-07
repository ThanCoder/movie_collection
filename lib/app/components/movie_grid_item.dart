import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/widgets/core/index.dart';

class MovieGridItem extends StatelessWidget {
  MovieModel movie;
  void Function(MovieModel movie) onClicked;
  MovieGridItem({
    super.key,
    required this.movie,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    // print('type: ${movie.infoType} - cover:${movie.coverPath}');
    return GestureDetector(
      onTap: () => onClicked(movie),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: MyImageFile(
                    width: double.infinity,
                    path: movie.coverPath,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(143, 51, 51, 51),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
