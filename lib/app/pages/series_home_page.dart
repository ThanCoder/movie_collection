import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/movie_content_menu_action_component.dart';
import 'package:movie_collections/app/components/movie_header_component.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/video_provider.dart';
import 'package:movie_collections/app/screens/video_player_screen.dart';
import 'package:movie_collections/app/widgets/my_scaffold.dart';
import 'package:provider/provider.dart';

class SeriesHomePage extends StatelessWidget {
  const SeriesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final videoList = context.watch<VideoProvider>().getList;

    return ValueListenableBuilder(
      valueListenable: currentMovieNotifier,
      builder: (context, movie, child) {
        if (movie == null) {
          return Center(child: Text('Movie မရှိပါ'));
        }
        return MyScaffold(
          appBar: AppBar(
            title: Text(movie.title),
            actions: [
              MovieContentMenuActionComponent(),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //header
                MovieHeaderComponent(movie: movie),
                //watch movie
                const Divider(),
                videoList.isNotEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VideoPlayerScreen(video: videoList.first),
                            ),
                          );
                        },
                        child: Text('Watch Movie'),
                      )
                    : Container(),
                const Divider(),
                //description
                Text(movie.description),
              ],
            ),
          ),
        );
      },
    );
  }
}
