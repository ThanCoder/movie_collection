import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/video_file_model.dart';
import 'package:movie_collections/app/pages/series_home_page.dart';
import 'package:movie_collections/app/pages/video_list_page.dart';
import 'package:movie_collections/app/screens/video_player_screen.dart';

class SeriesMovieContentPage extends StatelessWidget {
  const SeriesMovieContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            SeriesHomePage(),
            VideoListPage(
              onClick: (VideoFileModel video) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(video: video),
                  ),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              text: 'Description',
              icon: const Icon(Icons.home),
            ),
            Tab(
              text: 'Video List',
              icon: const Icon(Icons.movie),
            ),
          ],
        ),
      ),
    );
  }
}
