import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/services/index.dart';
import 'package:movie_collections/app/widgets/index.dart';

class MovieBookmarkButton extends StatefulWidget {
  MovieModel movie;
  MovieBookmarkButton({super.key, required this.movie});

  @override
  State<MovieBookmarkButton> createState() => _MovieBookmarkButtonState();
}

class _MovieBookmarkButtonState extends State<MovieBookmarkButton> {
  bool isLoading = true;
  bool isExists = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    final res =
        await BookmarkServices.instance.isExists(movieId: widget.movie.id);
    if (!mounted) return;
    setState(() {
      isExists = res;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        children: [
          SizedBox(
            width: 25,
            height: 25,
            child: TLoader(
              size: 25,
            ),
          ),
        ],
      );
    }
    return IconButton(
      onPressed: () async {
        await BookmarkServices.instance.toggle(movieId: widget.movie.id);
        setState(() {
          isExists = !isExists;
        });
      },
      icon: Icon(
          color: isExists ? Colors.red : Colors.blue,
          isExists
              ? Icons.bookmark_remove_rounded
              : Icons.bookmark_add_rounded),
    );
  }
}
