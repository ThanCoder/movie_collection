import 'package:flutter/material.dart';
import 'package:movie_collections/app/enums/movie_info_types.dart';
import 'package:movie_collections/app/extensions/index.dart';
import 'package:movie_collections/app/models/episode_model.dart';
import 'package:movie_collections/app/models/season_model.dart';

class SeasonListView extends StatelessWidget {
  List<SeasonModel> list;
  void Function(SeasonModel season)? onMenuOpened;
  void Function(SeasonModel season)? onAddClicked;
  void Function(EpisodeModel episode) onEpisodeClicked;
  void Function(SeasonModel season, EpisodeModel episode)?
      onEpisodeDeleteClicked;
  void Function(SeasonModel season, EpisodeModel episode)? onEpisodeEditClicked;
  void Function(SeasonModel season, EpisodeModel episode)?
      onEpisodeRestoreClicked;
  SeasonListView({
    super.key,
    required this.list,
    this.onMenuOpened,
    required this.onEpisodeClicked,
    this.onAddClicked,
    this.onEpisodeDeleteClicked,
    this.onEpisodeEditClicked,
    this.onEpisodeRestoreClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final season = list[index];
        return ExpansionTile(
          title: GestureDetector(
            onLongPress: () {
              if (onMenuOpened != null) {
                onMenuOpened!(season);
              }
            },
            onSecondaryTap: () {
              if (onMenuOpened != null) {
                onMenuOpened!(season);
              }
            },
            child: Text(
                'Season: ${season.seasonNumber.toString()} Episodes: ${season.episodes.length}'),
          ),
          children: [
            ...List.generate(season.episodes.length, (index) {
              final ep = season.episodes[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Episode: ${ep.episodeNumber.toString()}'),
                  Text('Title: ${ep.title}'),
                  Text('InfoType: ${ep.infoType.toCaptalize()}'),
                  Text('Size: ${ep.size.toDouble().toFileSizeLabel()}'),
                  Text(
                      'Date: ${DateTime.fromMillisecondsSinceEpoch(ep.date).toParseTime()}'),
                  Text(
                      'Ago: ${DateTime.fromMillisecondsSinceEpoch(ep.date).toTimeAgo()}'),
                  // Text(MovieSeasonServices.getVideoPath(season.movieId, ep)),
                  Row(
                    children: [
                      onEpisodeEditClicked == null
                          ? SizedBox.shrink()
                          : IconButton(
                              onPressed: () =>
                                  onEpisodeEditClicked!(season, ep),
                              icon: Icon(Icons.edit),
                            ),
                      //restore
                      onEpisodeRestoreClicked == null ||
                              ep.infoType != MovieInfoTypes.data.name
                          ? SizedBox.shrink()
                          : IconButton(
                              color: Colors.yellow,
                              onPressed: () =>
                                  onEpisodeRestoreClicked!(season, ep),
                              icon: Icon(Icons.restore_rounded),
                            ),
                      //delete
                      onEpisodeDeleteClicked == null
                          ? SizedBox.shrink()
                          : IconButton(
                              color: Colors.red,
                              onPressed: () =>
                                  onEpisodeDeleteClicked!(season, ep),
                              icon: Icon(Icons.delete_forever),
                            ),
                    ],
                  ),
                  Divider(),
                ],
              );
            }),
            onAddClicked == null
                ? SizedBox.shrink()
                : IconButton(
                    onPressed: () => onAddClicked!(season),
                    icon: Icon(Icons.add),
                  ),
          ],
        );
      },
    );
  }
}
