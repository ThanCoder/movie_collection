import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/services/movie_services.dart';
import 'package:movie_collections/app/utils/app_util.dart';
import 'package:movie_collections/app/widgets/my_image_file.dart';

class MovieHeaderComponent extends StatelessWidget {
  MovieModel movie;
  MovieHeaderComponent({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        SizedBox(
          width: 150,
          height: 170,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child:
                MyImageFile(path: getMovieCoverSourcePath(movieId: movie.id)),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                Icon(Icons.title),
                Text(movie.title),
              ],
            ),
            movie.genres.isNotEmpty
                ? Row(
                    spacing: 10,
                    children: [
                      Icon(Icons.generating_tokens_sharp),
                      Text(movie.genres),
                    ],
                  )
                : Container(),
            Row(
              spacing: 10,
              children: [
                Icon(Icons.timelapse),
                Text(getParseMinutes(movie.durationInMinutes)),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Icon(
                  Icons.star_border,
                  color: Colors.yellow,
                ),
                Text(movie.imdb.toString()),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Icon(Icons.date_range_outlined),
                Text(movie.year.toString()),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Icon(Icons.date_range),
                Text(getParseDate(movie.date)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
