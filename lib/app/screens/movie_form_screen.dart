import 'package:flutter/material.dart';
import 'package:movie_collections/app/pages/index.dart';

class MovieFormScreen extends StatelessWidget {
  const MovieFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            MovieFormHomePage(),
            MovieFormContentCoverPage(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              text: 'Home',
            ),
            Tab(
              text: 'Content Cover',
            ),
          ],
        ),
      ),
    );
  }
}
