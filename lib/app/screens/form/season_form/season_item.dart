import 'package:flutter/material.dart';
import 'package:mc_v2/app/models/episode.dart';
import 'package:mc_v2/app/models/season.dart';
import 'package:real_path_file_selector/ui/widgets/core/t_chip.dart';

class SeasonItem extends StatelessWidget {
  int index;
  Season season;
  void Function(int index) addEpisode;
  void Function(int index, Episode episode)? onClickEpisode;
  void Function(int index, Episode episode)? onDeleteEpisode;
  void Function(int index)? deleteSeason;
  SeasonItem({
    super.key,
    required this.index,
    required this.season,
    required this.addEpisode,
    this.onClickEpisode,
    this.onDeleteEpisode,
    this.deleteSeason,
  });

  List<Widget> _getEpisode() {
    return season.episodes
        .map(
          (ep) => TChip(
            onClick: onClickEpisode == null
                ? null
                : () {
                    onClickEpisode!(index, ep);
                  },
            onDelete: onDeleteEpisode == null
                ? null
                : () {
                    onDeleteEpisode!(index, ep);
                  },
            title: 'Ep${ep.episodeNumber}',
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('S${season.seasonNumber}'),
            // ep
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                ..._getEpisode(),
                IconButton(
                  color: Colors.green,
                  onPressed: () => addEpisode(index),
                  icon: Icon(Icons.add_circle),
                ),
                IconButton(
                  color: Colors.red,
                  onPressed:
                      deleteSeason == null ? null : () => deleteSeason!(index),
                  icon: Icon(Icons.delete_forever),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
