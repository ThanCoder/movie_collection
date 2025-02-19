import 'package:flutter/material.dart';
import 'package:movie_collections/app/pages/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: [
            HomePage(),
            GenresPage(),
            LibraryPage(),
            HomeMorePage(),
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
            Tab(
              text: 'More',
              icon: const Icon(Icons.grid_view_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
