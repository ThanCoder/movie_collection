import 'package:flutter/material.dart';
import 'package:movie_collections/app/pages/form/movie_season_form_page.dart';
import 'package:movie_collections/app/pages/form/movie_series_form_home_page.dart';
import 'package:movie_collections/app/pages/index.dart';

class MovieSeriesFormScreen extends StatelessWidget {
  const MovieSeriesFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            MovieSeriesFormHomePage(),
            MovieSeasonFormPage(),
            MovieFormContentCoverPage(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              text: 'Home',
            ),
            Tab(
              text: 'Season',
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
