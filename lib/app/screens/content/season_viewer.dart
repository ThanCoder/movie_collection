import 'package:flutter/material.dart';
import 'package:mc_v2/app/models/episode.dart';
import 'package:mc_v2/app/models/season.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/models/video_type.dart';
import 'package:t_widgets/widgets/index.dart';

class SeasonViewer extends StatefulWidget {
  VideoItem video;
  void Function(Episode episode)? onClicked;
  void Function(Episode episode)? onDeleted;
  SeasonViewer({
    super.key,
    required this.video,
    this.onClicked,
    this.onDeleted,
  });

  @override
  State<SeasonViewer> createState() => _SeasonViewerState();
}

class _SeasonViewerState extends State<SeasonViewer> {
  List<Season> seasons = [];
  Season? currentSeason;
  Episode? currentEp;

  @override
  void initState() {
    seasons = widget.video.seasons;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.video.type != VideoType.series) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Season'),
          // Season
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: List.generate(
              seasons.length,
              (index) {
                final season = seasons[index];
                return TChip(
                  avatar: currentSeason != null &&
                          currentSeason!.seasonNumber == season.seasonNumber
                      ? Icon(Icons.check)
                      : null,
                  onClick: () {
                    currentSeason = season;
                    setState(() {});
                  },
                  title: Text('S${season.seasonNumber}'),
                );
              },
            ),
          ),
          // Ep
          currentSeason == null
              ? SizedBox.shrink()
              : Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: List.generate(
                    currentSeason!.episodes.length,
                    (index) {
                      final ep = currentSeason!.episodes[index];
                      return TChip(
                        avatar: currentEp != null &&
                                currentEp!.episodeNumber == ep.episodeNumber
                            ? Icon(Icons.check)
                            : null,
                        title: Text('Ep${ep.episodeNumber}'),
                        onClick: () {
                          if (widget.onClicked != null) {
                            widget.onClicked!(ep);
                            currentEp = ep;
                            setState(() {});
                          }
                        },
                        onDelete: widget.onDeleted == null
                            ? null
                            : () {
                                widget.onDeleted!(ep);
                              },
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
