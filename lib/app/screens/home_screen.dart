import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_collections/app/components/add_movie_form_path_chooser_component.dart';
import 'package:movie_collections/app/components/add_movie_from_path_btn_component.dart';
import 'package:movie_collections/app/constants.dart';
import 'package:movie_collections/app/customs_class/movie_search_delegate.dart';
import 'package:movie_collections/app/dialogs/rename_dialog.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/pages/genres_page.dart';
import 'package:movie_collections/app/pages/home_page.dart';
import 'package:movie_collections/app/pages/library_page.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/screens/delete_movie_screen.dart';
import 'package:movie_collections/app/screens/movie_content_screen.dart';
import 'package:movie_collections/app/screens/movie_form_screen.dart';
import 'package:movie_collections/app/widgets/my_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return MyScaffold(
      contentPadding: 4,
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
      body: _Tabs(),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            HomePage(),
            GenresPage(),
            LibraryPage(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              text: 'Home',
              icon: const Icon(Icons.home),
            ),
            Tab(
              text: 'Genres',
              icon: const Icon(Icons.library_add_check_rounded),
            ),
            Tab(
              text: 'Library',
              icon: const Icon(Icons.my_library_books),
            ),
          ],
        ),
      ),
    );
  }
}
