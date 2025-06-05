import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mc_v2/app/models/episode.dart';
import 'package:mc_v2/app/models/season.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/platforms/platform_libs.dart';
import 'package:mc_v2/app/screens/form/season_form/season_chooser_dialog.dart';
import 'package:mc_v2/app/screens/form/season_form/season_item.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class SeasonFormScreen extends StatefulWidget {
  VideoItem video;
  void Function(VideoItem video) onRefersh;
  SeasonFormScreen({
    super.key,
    required this.video,
    required this.onRefersh,
  });

  @override
  State<SeasonFormScreen> createState() => _SeasonFormScreenState();
}

class _SeasonFormScreenState extends State<SeasonFormScreen> {
  late VideoItem video;
  @override
  void initState() {
    video = widget.video;
    super.initState();
  }

  void _addSeason() {
    showDialog(
      context: context,
      builder: (context) => TRenameDialog(
        title: 'New Season',
        text: video.getLatestSeason == null
            ? '1'
            : '${video.getLatestSeason!.seasonNumber + 1}',
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textInputType: TextInputType.number,
        onCheckIsError: (text) {
          if (int.tryParse(text) == null) return 'required number';
          if (video.isSeasonExists(int.parse(text))) {
            return 'ရှိနေပါတယ်';
          }
          return null;
        },
        onSubmit: (text) {
          if (int.tryParse(text) == null) return;
          video.addSeason(Season.create(int.parse(text), episodes: []));
          setState(() {});
          widget.video.update(video);
        },
      ),
    );
  }

  void _addEpisodeFromChooser(int index) async {
    final res = await PlatformLibs.videoPathChooser(context);
    final season = video.seasons[index];
    int i = 1;
    for (var path in res) {
      season.episodes.add(Episode.fromPath(path, episodeNumber: i));
      i++;
    }
    video.seasons[index] = season;
    setState(() {});
    widget.video.update(video);
  }

  void _addDropEpisode(DropDoneDetails details) {
    if (details.files.isEmpty || video.seasons.isEmpty) return;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => SeasonChooserDialog(
        list: video.seasons,
        onChoosed: (choosedSeason, startEp) {
          final index = video.seasons
              .indexWhere((e) => e.seasonNumber == choosedSeason.seasonNumber);
          final season = video.seasons[index];
          if (index == -1) {
            debugPrint('index is -1');
            return;
          }
          int i = startEp;
          for (var file in details.files) {
            final mime = lookupMimeType(file.path) ?? '';
            if (!mime.startsWith('video')) continue;

            season.episodes.add(Episode.fromPath(file.path, episodeNumber: i));
            i++;
          }
          video.seasons[index] = season;
          setState(() {});
          widget.video.update(video);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        widget.onRefersh(video);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Season Form'),
        ),
        body: DropTarget(
          enable: true,
          onDragDone: _addDropEpisode,
          child: ListView.builder(
            itemCount: widget.video.seasons.length,
            itemBuilder: (context, index) {
              final season = widget.video.seasons[index];
              return SeasonItem(
                index: index,
                season: season,
                addEpisode: _addEpisodeFromChooser,
                deleteSeason: (index) {
                  video.seasons.removeAt(index);
                  setState(() {});
                  widget.video.update(video);
                },
                onDeleteEpisode: (index, episode) async {
                  final season = video.seasons[index];
                  await season.deleteEpisode(episode);

                  video.seasons[index] = season;
                  setState(() {});
                  widget.video.update(video);
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addSeason,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
