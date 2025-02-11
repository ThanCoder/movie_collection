import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/services/movie_services.dart';
import 'package:movie_collections/app/widgets/my_image_file.dart';

class MovieListView extends StatelessWidget {
  List<MovieModel> movieList;
  void Function(MovieModel movie) onClick;
  MovieListView({super.key, required this.movieList, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: movieList.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        crossAxisSpacing: 5,
        maxCrossAxisExtent: 200,
        mainAxisExtent: 240,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        final movie = movieList[index];
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onClick(movie),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: MyImageFile(
                              path: getMovieCoverSourcePath(movieId: movie.id),
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Text(movie.title),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(209, 19, 19, 19),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            spacing: 5,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 20,
                              ),
                              Text(movie.imdb.toString()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
