import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:movie_collections/app/components/drop_filepath_container.dart';
import 'package:movie_collections/app/components/season_list_view.dart';
import 'package:movie_collections/app/dialogs/episode_add_form_dialog.dart';
import 'package:movie_collections/app/dialogs/episode_edit_form_dialog.dart';
import 'package:movie_collections/app/dialogs/index.dart';
import 'package:movie_collections/app/lib_components/path_chooser.dart';
import 'package:movie_collections/app/models/season_model.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/providers/series_provider.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

class MovieSeasonFormPage extends StatefulWidget {
  const MovieSeasonFormPage({super.key});

  @override
  State<MovieSeasonFormPage> createState() => _MovieSeasonFormPageState();
}

class _MovieSeasonFormPageState extends State<MovieSeasonFormPage> {
  List<String> choosedPathList = [];
  SeasonModel? currentSeason;
  String? movieId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  void init() {
    final movie = context.read<MovieProvider>().getCurrent;
    if (movie == null) return;
    movieId = movie.id;
    context.read<SeriesProvider>().intSeasonList(movie.id);
  }

  void _pickFiles() async {
    try {
      choosedPathList = await platformVideoPathChooser(context);
      if (choosedPathList.isEmpty) return;
      _addConfirm();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _onDroped(List<DropItem> items) {
    choosedPathList = items
        .where((file) => (lookupMimeType(file.path) ?? '').startsWith('video'))
        .map((file) => file.path)
        .toList();
    _addConfirm();
  }

  void _addConfirm() {
    if (currentSeason == null) return;
    showDialog(
      context: context,
      builder: (context) => EpisodeAddFormDialog(
        onSubmited: (movieInfoType) {
          context.read<SeriesProvider>().addEpisodesPathList(
                season: currentSeason!,
                infoType: movieInfoType.name,
                pathList: choosedPathList,
              );
        },
      ),
    );
  }

  // add season box
  void _addSeason() {
    if (movieId == null) return;
    showDialog(
      context: context,
      builder: (context) => RenameDialog(
        renameLabelText: Text('Season Number'),
        renameText: _getSeasonNumber().toString(),
        onCancel: () {},
        onSubmit: (text) {
          if (int.tryParse(text) == null) return;

          int seasonNumber = int.parse(text);
          context.read<SeriesProvider>().addSeason(
                movieId: movieId!,
                seasonNumber: seasonNumber,
              );
        },
      ),
    );
  }

  int _getSeasonNumber() {
    final list = context.read<SeriesProvider>().seasonList;
    if (list.isEmpty) return 1;
    final latest = List.of(list)
      ..sort((a, b) => b.seasonNumber.compareTo(a.seasonNumber));

    return latest.first.seasonNumber + 1;
  }

  void _deleteSeasonConfirm(SeasonModel season) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        contentText: 'Season ${season.seasonNumber} ကိုဖျက်ချင်တာ သေချာပြီလား?',
        onCancel: () {},
        onSubmit: () {
          context.read<SeriesProvider>().deleteSeason(season: season);
        },
      ),
    );
  }

  void _showSeasonMenu(SeasonModel season) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Column(
          spacing: 3,
          children: [
            Text('Season: ${season.seasonNumber.toString()}'),
            ListTile(
              iconColor: Colors.red,
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deleteSeasonConfirm(season);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickDirPath() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => RenameDialog(
        renameLabelText: Text('Path ထည့်ပါ'),
        renameText: '',
        onCancel: () {},
        onSubmit: (text) {
          final dir = Directory(text);
          if (!dir.existsSync()) return;
          for (var file in dir.listSync()) {
            if (file.statSync().type != FileSystemEntityType.file) continue;
            final mime = lookupMimeType(file.path) ?? '';
            if (!mime.startsWith('video')) continue;
            choosedPathList.add(file.path);
          }
          _addConfirm();
        },
      ),
    );
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('Add From Path'),
              onTap: () {
                Navigator.pop(context);
                _pickDirPath();
              },
            ),
            ListTile(
              title: Text('Path Selector'),
              onTap: () {
                Navigator.pop(context);
                _pickFiles();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SeriesProvider>();
    final isLoading = provider.isLoading;
    final list = provider.seasonList;
    return MyScaffold(
      appBar: AppBar(
        title: Text('Season Form'),
        actions: [
          IconButton(
            onPressed: _addSeason,
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),
      body: isLoading
          ? TLoader()
          : DropFilepathContainer(
              onDroped: _onDroped,
              child: list.isEmpty
                  ? Text('list empty ')
                  : SeasonListView(
                      list: list,
                      onMenuOpened: _showSeasonMenu,
                      onEpisodeClicked: (episode) {},
                      onAddClicked: (season) {
                        currentSeason = season;
                        _showAddMenu();
                      },
                      onEpisodeDeleteClicked: (season, episode) {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmDialog(
                            contentText:
                                '`${episode.title}` ဖျက်ချင်တာ သေချာပြီလား',
                            onCancel: () {},
                            onSubmit: () {
                              context
                                  .read<SeriesProvider>()
                                  .deleteEpisode(season, episode);
                            },
                          ),
                        );
                      },
                      onEpisodeRestoreClicked: (season, episode) {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmDialog(
                            contentText:
                                '`${episode.title}` အပြင်ထုတ်ချင်တာ သေချာပြီလား',
                            onCancel: () {},
                            onSubmit: () {
                              context
                                  .read<SeriesProvider>()
                                  .restoreEpisode(season, episode);
                            },
                          ),
                        );
                      },
                      onEpisodeEditClicked: (season, episode) {
                        showDialog(
                          context: context,
                          builder: (context) => EpisodeEditFormDialog(
                            episode: episode,
                            onSubmited: (episodeEdited) {
                              context
                                  .read<SeriesProvider>()
                                  .updateEpisode(season, episodeEdited);
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
