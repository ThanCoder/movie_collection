import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mc_v2/models/video_item.dart';
import 'package:mc_v2/notifiers/drop_notifier.dart';
import 'package:mc_v2/route_helper.dart';
import 'package:mc_v2/screens/content/content_menu_bottom_sheet.dart';
import 'package:mc_v2/screens/content/header_component.dart';
import 'package:mc_v2/screens/content/my_listener/content_screen_event_listener.dart';
import 'package:mc_v2/screens/content/platforms_media_quary.dart';
import 'package:mc_v2/screens/content/season_viewer.dart';
import 'package:mc_v2/screens/content/video_player_component.dart';
import 'package:mc_v2/screens/content/video_random_sliver_list.dart';
import 'package:t_widgets/extensions/platform_extension.dart';

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

  List<Widget> _getDesktopAppBar() {
    if (PlatformExtension.isDesktop()) {
      return [
        SliverAppBar(
          snap: true,
          floating: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
      ];
    }
    return [];
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
        body: ValueListenableBuilder(
          valueListenable: VideoItem.db.listenable(),
          builder: (context, db, child) {
            final video = VideoItem.getId(widget.video.id);
            if (video == null) {
              return Text('video မရှိပါ');
            }
            return Stack(
              children: [
                // Positioned.fill(
                //   child: TImageFile(path: video.coverPath),
                // ),
                CustomScrollView(
                  slivers: [
                    ..._getDesktopAppBar(),
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      collapsedHeight: PlatformsMediaQuary.getPlayerHeight,
                      expandedHeight: PlatformsMediaQuary.getPlayerHeight,
                      floating: true,
                      pinned: true,
                      flexibleSpace: VideoPlayerComponent(video: video),
                    ),
                    // player

                    SliverToBoxAdapter(child: SizedBox(height: 10)),
                    SliverToBoxAdapter(
                      child: TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          isShowPlayer = !isShowPlayer;
                          setState(() {});
                          ContentScreenEventSender.instance
                              .changeCoverAndPlayer(isShowPlayer);
                        },
                        child: Text(
                          isShowPlayer ? 'Show Cover' : 'Play',
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
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Random'),
                      ),
                    ),
                    // random list
                    VideoRandomSliverList(
                      currentVideo: video,
                      onClicked: (video) {
                        goContentScreen(context, video);
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
