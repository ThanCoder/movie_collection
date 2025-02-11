import 'package:flutter/material.dart';
import 'package:movie_collections/app/pages/movie_form_home_page.dart';
import 'package:movie_collections/app/pages/movie_form_video_page.dart';

class MovieFormScreen extends StatelessWidget {
  const MovieFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(children: [
          const MovieFormHomePage(),
          const MovieFormVideoPage(),
        ]),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              text: 'Movie Form',
              icon: Icon(Icons.home),
            ),
            Tab(
              text: 'Video Form',
              icon: Icon(Icons.video_file),
            ),
          ],
        ),
      ),
    );
  }
}
