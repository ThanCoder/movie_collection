import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/movie_content_menu_action_component.dart';
import 'package:movie_collections/app/components/movie_header_component.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/providers/video_provider.dart';
import 'package:movie_collections/app/screens/video_player_screen.dart';
import 'package:movie_collections/app/widgets/my_scaffold.dart';
import 'package:provider/provider.dart';

class SingleMovieContentPage extends StatefulWidget {
  const SingleMovieContentPage({super.key});

  @override
  State<SingleMovieContentPage> createState() => _SingleMovieContentPageState();
}

class _SingleMovieContentPageState extends State<SingleMovieContentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VideoProvider>(context, listen: false).initList(
        movieId: currentMovieNotifier.value!.id,
      );
    });
  }

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
                const Divider(),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
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
                  ],
                ),
                movie.description.isNotEmpty ? const Divider() : Container(),
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
