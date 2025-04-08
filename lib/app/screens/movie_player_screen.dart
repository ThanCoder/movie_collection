import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/genres_wrap_view.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/components/movie_tag_list.dart';
import 'package:movie_collections/app/components/season_wrap_list_view.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/extensions/index.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/providers/series_video_player_provider.dart';
import 'package:movie_collections/app/services/movie_content_cover_serices.dart';
import 'package:movie_collections/app/services/tag_services.dart';
import 'package:movie_collections/app/video_player/player_mobile_page.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/screens/all_movie_screen.dart';
import 'package:movie_collections/app/video_player/series_video_player.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

class MoviePlayerScreen extends StatefulWidget {
  const MoviePlayerScreen({super.key});

  @override
  State<MoviePlayerScreen> createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  bool isShowCover = true;

  void _showImage(String path) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: MyImageFile(
          path: path,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _getContentCoverWidget() {
    final provider = context.watch<MovieProvider>();
    final isLoading = provider.isLoading;
    final movie = provider.getCurrent!;
    final list = provider.contentCoverList;
    if (isLoading) {
      return MyImageFile(path: movie.coverPath);
    }
    if (isShowCover) {
      if (list.isEmpty) {
        return MyImageFile(path: movie.coverPath);
      }
      // return MyImageFile(path: movie.coverPath);
      return CarouselView.weighted(
        onTap: (value) => _showImage(
          MovieContentCoverSerices.getImagePath(movie.id, list[value]),
        ),
        // itemExtent: 200,
        flexWeights: [2, 1],
        children: list
            .map((name) => MyImageFile(
                  path: MovieContentCoverSerices.getImagePath(movie.id, name),
                  // fit: BoxFit.fill,
                ))
            .toList(),
      );
    }
    if (movie.type == MovieTypes.series.name) {
      return SeriesVideoPlayer();
    }
    return PlayerMobilePage();
  }

  Widget _getContent() {
    final movie = context.watch<MovieProvider>().getCurrent;
    if (movie == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(movie.title),
            Text(movie.size.toDouble().toFileSizeLabel()),
            //date
            Text(DateTime.fromMillisecondsSinceEpoch(movie.date).toParseTime()),
            Text(DateTime.fromMillisecondsSinceEpoch(movie.date).toTimeAgo()),
            //watch button
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 201, 37, 25),
              ),
              onPressed: () {
                setState(() {
                  isShowCover = !isShowCover;
                });
              },
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  isShowCover ? 'ကြည့်မည်' : 'Show Cover',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            //book mark
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                MovieBookmarkButton(movie: movie),
              ],
            ),
            // Tags
            MovieTagList(
              movie: movie,
              onClicked: (name) {
                final list = TagServices.instance.getMovieList(name);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllMovieScreen(list: list, title: '#$name'),
                  ),
                );
              },
            ),
            const Divider(),
            //descritpion
            ExpandableText(
              movie.content,
              expandText: 'See More',
              collapseText: 'See Less',
              maxLines: 4,
              linkColor: Colors.blue,
              collapseOnTextTap: true,
            ),
            //genres
            GenresWrapView(
              title: 'အမျိုးအစားများ',
              genres: movie.type,
              onClicked: (genres) {
                print(genres);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<MovieModel> _getRandomList() {
    final list = List.of(context.read<MovieProvider>().getList);
    final movie = context.read<MovieProvider>().getCurrent;
    if (movie == null) return [];
    list.shuffle();
    return list;
  }

  List<MovieModel> _getRelatedList() {
    final list = context.read<MovieProvider>().getList;
    final movie = context.read<MovieProvider>().getCurrent;
    if (movie == null) return [];
    return list.where((mv) => mv.type == movie.type).toList();
  }

  Widget _getSeriesContent() {
    final movie = context.watch<MovieProvider>().getCurrent!;
    final seriesVideoPlayerProvider =
        context.watch<SeriesVideoPlayerProvider>();

    if (movie.type == MovieTypes.series.name) {
      return SeasonWrapListView(
        movie: movie,
        onLoaded: (epList) {
          seriesVideoPlayerProvider.setMovidId(movie.id);
          seriesVideoPlayerProvider.setList(epList);
        },
        onSeasonChanged: (epList) {
          seriesVideoPlayerProvider.setList(epList);
        },
        onEpisodeClicked: (index, episode) {
          seriesVideoPlayerProvider.setCurrentIndex(index);
          isShowCover = false;
          setState(() {});
        },
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      contentPadding: 0,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600,
          ),
          child: CustomScrollView(
            slivers: [
              //app bar
              SliverAppBar(
                title: Text('အသေးစိတ်'),
                actions: [
                  MovieContentActionButton(
                    onDoned: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              //movie player
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: PlatformExtension.isDesktop() ? 250 : 200,
                collapsedHeight: PlatformExtension.isDesktop() ? 250 : 150,
                pinned: true,
                floating: true,
                // flexibleSpace: _getCurrentPlayer(),
                flexibleSpace: _getContentCoverWidget(),
              ),

              //content
              SliverToBoxAdapter(
                child: _getContent(),
              ),
              // series list
              SliverToBoxAdapter(
                child: _getSeriesContent(),
              ),
              //related
              SliverToBoxAdapter(
                child: Card(
                  child: MovieSeeAllListView(
                    title: 'Related',
                    width: 100,
                    height: 130,
                    fontSize: 10,
                    list: _getRelatedList(),
                    onClicked: (movie) async {
                      await context.read<MovieProvider>().setCurrent(movie);
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoviePlayerScreen(),
                        ),
                      );
                    },
                    onSeeAllClicked: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllMovieScreen(
                            title: 'Related',
                            list: _getRelatedList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              //random list
              SliverToBoxAdapter(
                child: Card(
                  child: MovieSeeAllListView(
                    title: 'Random',
                    width: 100,
                    height: 130,
                    fontSize: 10,
                    list: _getRandomList(),
                    onClicked: (movie) async {
                      await context.read<MovieProvider>().setCurrent(movie);
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoviePlayerScreen(),
                        ),
                      );
                    },
                    onSeeAllClicked: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllMovieScreen(
                            title: 'Random',
                            list: _getRandomList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
