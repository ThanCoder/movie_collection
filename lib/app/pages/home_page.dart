import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_collections/app/constants.dart';
import 'package:movie_collections/app/customs/movie_search_delegate.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/widgets/my_scaffold.dart';
import 'package:movie_collections/app/widgets/t_loader.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../components/index.dart';
import '../dialogs/index.dart';
import '../models/index.dart';
import '../screens/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> init() async {
    await context.read<MovieProvider>().initList();
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: [
          //new movie
          ListTile(
            onTap: () {
              Navigator.pop(context);
              _createNewMovie();
            },
            leading: const Icon(Icons.add_circle),
            title: Text('New Movie'),
          ),
          AddMovieFromPathBtnComponent(),
          AddMovieFormPathChooserComponent(),
          ListTile(
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeleteMovieScreen(),
                ),
              );
            },
            leading: const Icon(Icons.delete),
            title: Text('Delete Multipl Movie'),
          ),
        ],
      ),
    );
  }

  void _createNewMovie() {
    showDialog(
      context: context,
      builder: (context) => RenameDialog(
        renameLabelText: Text('Movie Title'),
        submitText: 'New Movie',
        renameExistsTextList: Hive.box<MovieModel>('movies')
            .values
            .map((mov) => mov.title)
            .toList(),
        onCancel: () {},
        onSubmit: (title) async {
          try {
            final newMovie = MovieModel(
              id: Uuid().v4(),
              title: title,
              year: DateTime.now().year,
            );
            Provider.of<MovieProvider>(context, listen: false)
                .add(movie: newMovie);
            //go form page
            currentMovieNotifier.value = newMovie;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieFormScreen(),
              ),
            );
          } catch (e) {
            debugPrint(e.toString());
          }
        },
      ),
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: MovieSearchDelegate(
        movieList: context.read<MovieProvider>().getMovieList,
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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final isLoading = provider.isLoading;
    final movieList = provider.getMovieList;
    return MyScaffold(
      appBar: AppBar(
        title: Text(appName),
        actions: [
          IconButton(
            onPressed: _showSearch,
            icon: const Icon(Icons.search),
          ),
          Platform.isLinux
              ? IconButton(
                  onPressed: () {
                    context.read<MovieProvider>().initList();
                  },
                  icon: const Icon(Icons.refresh),
                )
              : Container(),
          IconButton(
            onPressed: _showMenu,
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: TLoader())
          : movieList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Empty List'),
                      IconButton(
                        onPressed: init,
                        icon: Icon(
                          Icons.refresh,
                          color: activeColor,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await init();
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
                ),
    );
  }
}
