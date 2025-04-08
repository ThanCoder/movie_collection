import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:movie_collections/app/components/drop_filepath_container.dart';
import 'package:movie_collections/app/components/season_list_view.dart';
import 'package:movie_collections/app/dialogs/episode_add_form_dialog.dart';
import 'package:movie_collections/app/dialogs/episode_edit_form_dialog.dart';
import 'package:movie_collections/app/dialogs/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

class MovieSeasonFormPage extends StatefulWidget {
  const MovieSeasonFormPage({super.key});

  @override
  State<MovieSeasonFormPage> createState() => _MovieSeasonFormPageState();
}

class _MovieSeasonFormPageState extends State<MovieSeasonFormPage> {
  List<String> choosedPathList = [];
  String? seasonId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  void init() {
    context.read<MovieProvider>().intSeasonList();
  }

  void _pickFiles() async {
    try {
      final items = await openFiles(
        acceptedTypeGroups: [
          XTypeGroup(mimeTypes: [
            'video/mp4',
            'video/mkv',
          ]),
        ],
      );
      choosedPathList = items
          .where(
              (file) => (lookupMimeType(file.path) ?? '').startsWith('video'))
          .map((file) => file.path)
          .toList();
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
    if (seasonId == null) return;
    showDialog(
      context: context,
      builder: (context) => EpisodeAddFormDialog(
        onSubmited: (movieInfoType) {
          context.read<MovieProvider>().addEpisodesPathList(
                seasonId: seasonId!,
                infoType: movieInfoType.name,
                pathList: choosedPathList,
              );
        },
      ),
    );
  }

  // add season box
  void _addSeason() {
    showDialog(
      context: context,
      builder: (context) => RenameDialog(
        renameLabelText: Text('Season Number'),
        renameText: _getSeasonNumber().toString(),
        onCancel: () {},
        onSubmit: (text) {
          if (int.tryParse(text) == null) return;

          int seasonNumber = int.parse(text);
          context.read<MovieProvider>().addSeason(
                seasonNumber: seasonNumber,
              );
        },
      ),
    );
  }

  int _getSeasonNumber() {
    final list = context.read<MovieProvider>().seasonList;
    if (list.isEmpty) return 1;
    final latest = List.of(list)
      ..sort((a, b) => b.seasonNumber.compareTo(a.seasonNumber));

    return latest.first.seasonNumber + 1;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
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
                      onEpisodeClicked: (episode) {},
                      onAddClicked: (season) {
                        seasonId = season.id;
                        _pickFiles();
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
                                  .read<MovieProvider>()
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
                                  .read<MovieProvider>()
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
                                  .read<MovieProvider>()
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
