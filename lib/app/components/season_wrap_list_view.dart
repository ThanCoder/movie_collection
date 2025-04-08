import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/episode_model.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/models/season_model.dart';
import 'package:movie_collections/app/services/movie_season_services.dart';
import 'package:real_path_file_selector/ui/widgets/index.dart';

class SeasonWrapListView extends StatefulWidget {
  MovieModel movie;
  void Function(List<EpisodeModel> episodeList)? onLoaded;
  void Function(List<EpisodeModel> episodeList)? onSeasonChanged;
  void Function(int index, EpisodeModel episode)? onEpisodeClicked;
  SeasonWrapListView({
    super.key,
    required this.movie,
    this.onEpisodeClicked,
    this.onLoaded,
    this.onSeasonChanged,
  });

  @override
  State<SeasonWrapListView> createState() => _SeasonWrapListViewState();
}

class _SeasonWrapListViewState extends State<SeasonWrapListView> {
  List<SeasonModel> list = [];
  List<EpisodeModel> epList = [];
  int currentIndex = 0;
  int currentEpIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  void init() async {
    list = await MovieSeasonServices.instance.getList(widget.movie.id);
    if (list.isNotEmpty) {
      epList = list.first.episodes;
    }
    if (widget.onLoaded != null) {
      widget.onLoaded!(epList);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 3,
          children: [
            Text('Season'),
            // Season
            Wrap(
              spacing: 3,
              runSpacing: 3,
              children: List.generate(list.length, (index) {
                final season = list[index];
                return TChip(
                  avatar: currentIndex == index ? Icon(Icons.check) : null,
                  title: 'S${season.seasonNumber}',
                  onClick: () {
                    currentIndex = index;
                    currentEpIndex = 0;
                    epList = season.episodes;
                    setState(() {});
                    if (widget.onSeasonChanged != null) {
                      widget.onSeasonChanged!(epList);
                    }
                  },
                );
              }),
            ),
            // episode
            Text('Episode'),
            Wrap(
              spacing: 3,
              runSpacing: 3,
              children: List.generate(epList.length, (index) {
                final ep = epList[index];
                return TChip(
                  avatar: currentEpIndex == index ? Icon(Icons.check) : null,
                  title: 'EP${ep.episodeNumber}',
                  onClick: () {
                    currentEpIndex = index;
                    setState(() {});
                    if (widget.onEpisodeClicked != null) {
                      widget.onEpisodeClicked!(index, ep);
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
