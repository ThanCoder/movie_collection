import 'package:flutter/material.dart';
import 'package:movie_collections/app/enums/index.dart';
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
            // title
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
            // info
            Positioned(
              child: Icon(
                size: 20,
                movie.infoType == MovieInfoTypes.info.name
                    ? Icons.info_rounded
                    : Icons.video_file,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
