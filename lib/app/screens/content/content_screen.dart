import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/models/video_type.dart';
import 'package:mc_v2/app/notifiers/drop_notifier.dart';
import 'package:mc_v2/app/route_helper.dart';
import 'package:mc_v2/app/screens/content/content_menu_bottom_sheet.dart';
import 'package:mc_v2/app/screens/content/header_component.dart';
import 'package:mc_v2/app/screens/content/my_listener/content_screen_event_listener.dart';
import 'package:mc_v2/app/screens/content/season_viewer.dart';
import 'package:mc_v2/app/screens/content/video_random_sliver_list.dart';
import 'package:mc_v2/my_libs/video_player_1.0.0/video_file_model.dart';
import 'package:t_widgets/widgets/t_image_file.dart';

class ContentScreen extends StatefulWidget {
  VideoItem video;
  ContentScreen({
    super.key,
    required this.video,
  });

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen>
    with ContentScreenEventListener {
  bool isShowPlayer = false;

  @override
  void initState() {
    ContentScreenEventSender.instance.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    ContentScreenEventSender.instance.removeListener(this);
    super.dispose();
  }

  void _onBackpress() {
    homeFileDropEnableNotifier.value = true;
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  void onChangedCoverAndPlayer(bool isShowPlayer) {
    this.isShowPlayer = isShowPlayer;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        _onBackpress();
      },
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: ValueListenableBuilder(
              valueListenable: VideoItem.db.listenable(),
              builder: (context, db, child) {
                final video = VideoItem.getId(widget.video.id);
                if (video == null) {
                  return Text('video မရှိပါ');
                }
                return Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          floating: true,
                          snap: true,
                          title: Text('Content'),
                        ),
                        SliverAppBar(
                            automaticallyImplyLeading: false,
                            collapsedHeight: 200,
                            expandedHeight: 300,
                            flexibleSpace: FlexibleSpaceBar(
                              background: TImageFile(path: video.coverPath),
                            )),
                        // player

                        SliverToBoxAdapter(child: SizedBox(height: 10)),
                        // watch button
                        SliverToBoxAdapter(
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              var title = video.title;
                              var source = video.filePath;
                              if (video.type == VideoType.series &&
                                  video.seasons.isNotEmpty &&
                                  video.seasons.first.episodes.isNotEmpty) {
                                title =
                                    video.seasons.first.episodes.first.title;
                                source =
                                    video.seasons.first.episodes.first.filePath;
                              }
                              goVideoPlayerScreen(
                                context,
                                videoFile: VideoFileModel(
                                  title: title,
                                  source: source,
                                ),
                              );
                            },
                            child: Text(
                              'Watch',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // header
                        SliverToBoxAdapter(
                          child: HeaderComponent(
                            video: video,
                            onMenuOpen: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => ContentMenuBottomSheet(
                                  video: video,
                                  onBackpress: _goBack,
                                ),
                              );
                            },
                          ),
                        ),
                        // season
                        SliverToBoxAdapter(
                          child: Card(
                              child: SeasonViewer(
                            video: video,
                            onClicked: (episode) {
                              ContentScreenEventSender.instance
                                  .changeCoverAndPlayer(true);
                              ContentScreenEventSender.instance
                                  .playVideoPlayer(episode.filePath);
                            },
                          )),
                        ),
                        // random list
                        VideoRandomSliverList(
                          currentVideo: video,
                          onClicked: (video) {
                            goContentScreen(context, video);
                          },
                          onMenuClicked: (video) {
                            showModalBottomSheet(
                              context: context,
                              builder: (ctx) =>
                                  ContentMenuBottomSheet(video: video),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
