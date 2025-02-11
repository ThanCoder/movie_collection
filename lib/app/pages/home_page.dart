import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/movie_list_view.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/screens/movie_content_screen.dart';
import 'package:movie_collections/app/widgets/t_loader.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).initList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final isLoading = provider.isLoading;
    final movieList = provider.getMovieList;
    if (isLoading) {
      return Center(child: TLoader());
    }
    if (movieList.isEmpty) {
      return Center(child: Text('empty list'));
    }
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 1200));
        init();
      },
      child: MovieListView(
        movieList: movieList,
        onClick: (movie) {
          currentMovieNotifier.value = movie;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieContentScreen(),
            ),
          );
        },
      ),
    );
  }
}
