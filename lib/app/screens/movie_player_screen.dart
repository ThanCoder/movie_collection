import 'package:flutter/material.dart';
import 'package:movie_collections/app/pages/video_player/player_desktop_page.dart';
import 'package:movie_collections/app/pages/video_player/player_mobile_page.dart';

class MoviePlayerScreen extends StatefulWidget {
  const MoviePlayerScreen({super.key});

  @override
  State<MoviePlayerScreen> createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  @override
  Widget build(BuildContext context) {
    // final provider = context.watch<MovieProvider>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final isBigScreen = constraints.maxWidth > 800;
        //desktop
        if (isBigScreen) {
          return PlayerDesktopPage();
        }
        return PlayerMobilePage();
      },
    );
  }
}
