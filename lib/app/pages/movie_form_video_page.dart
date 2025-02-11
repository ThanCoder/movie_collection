import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_collections/app/components/app_components.dart';
import 'package:movie_collections/app/dialogs/confirm_dialog.dart';
import 'package:movie_collections/app/dialogs/rename_dialog.dart';
import 'package:movie_collections/app/models/video_file_model.dart';
import 'package:movie_collections/app/notifiers/movie_notifier.dart';
import 'package:movie_collections/app/pages/video_list_page.dart';
import 'package:movie_collections/app/providers/video_provider.dart';
import 'package:movie_collections/app/screens/video_player_screen.dart';
import 'package:movie_collections/app/services/app_services.dart';
import 'package:movie_collections/app/services/movie_services.dart';
import 'package:movie_collections/app/utils/path_util.dart';
import 'package:movie_collections/app/widgets/my_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MovieFormVideoPage extends StatefulWidget {
  const MovieFormVideoPage({super.key});

  @override
  State<MovieFormVideoPage> createState() => _MovieFormVideoPageState();
}

class _MovieFormVideoPageState extends State<MovieFormVideoPage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<VideoProvider>()
          .initList(movieId: currentMovieNotifier.value!.id);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _addDirPath() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RenameDialog(
        renameLabelText: Text('Dir Path ထည့်ပေးပါ'),
        renameText: '',
        onCancel: () {},
        onSubmit: (path) {
          _addFromDirPath(path, context);
        },
      ),
    );
  }

  void _addFromDirPath(String dirPath, BuildContext context) async {
    try {
      final files = Directory(dirPath).listSync();

      //filtering existing title
      final box = Hive.box<VideoFileModel>(VideoProvider.boxName);
      final filteredVideoCurrentMovieId = box.values
          .where((vd) => vd.movidId == currentMovieNotifier.value!.id)
          .toList();
      final existingTitle =
          filteredVideoCurrentMovieId.map((mv) => mv.title).toSet();
      final filteredVideo = files.where((f) {
        if (f.statSync().type != FileSystemEntityType.file) {
          return false;
        }
        return !existingTitle.contains(getBasename(f.path).split('.').first);
      }).toList();
      //parse video list
      final videoList = filteredVideo.map((file) {
        //add db
        return VideoFileModel(
          id: Uuid().v4(),
          movidId: currentMovieNotifier.value!.id,
          title: getBasename(file.path).split('.').first,
          path: file.path,
          size: file.statSync().size,
          date: file.statSync().modified.millisecondsSinceEpoch,
        );
      }).toList();

      context.read<VideoProvider>().addMultiple(videoList: videoList);
    } catch (e) {
      _showDiaMsg(e.toString());
    }
  }

  void _setCoverPath(String videoCoverPath) {
    try {
      final videoCover = File(videoCoverPath);
      if (videoCover.existsSync()) {
        final movieCover = File(
            getMovieCoverSourcePath(movieId: currentMovieNotifier.value!.id));
        movieCover.writeAsBytesSync(videoCover.readAsBytesSync());
        //clear image
        clearAndRefreshImage();
        //msg
        showMessage(context, 'Cover ထည့်သွင်းပြီးပါပြီ');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _addFromChooser() {
    context.read<VideoProvider>().addMultipleVideoFromChooser();
  }

  //dialog
  void _showDiaMsg(String msg) {
    showDialogMessage(context, msg);
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.pop(context);
              _addFromChooser();
            },
            leading: const Icon(Icons.move_to_inbox),
            title: Text('From Path (Move)'),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              _addDirPath();
            },
            leading: const Icon(Icons.move_to_inbox),
            title: Text('From Path (အချက်အလက်ပဲ ကူးယူ)'),
          ),
        ],
      ),
    );
  }

  void _deleteConfirm(VideoFileModel video) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'အတည်ပြုခြင်း',
        contentText: 'သင်က "${video.title}" ကိုဖျက်ချင်တာ သေချာပြီလား?',
        onCancel: () {},
        onSubmit: () {
          context.read<VideoProvider>().delete(video: video);
        },
      ),
    );
  }

  void _showOptionMenu(VideoFileModel video) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: [
          //open
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(video: video),
                ),
              );
            },
            leading: const Icon(Icons.play_circle),
            title: Text('Open Video'),
          ),
          //set cover
          ListTile(
            onTap: () {
              Navigator.pop(context);
              _setCoverPath(video.coverPath);
            },
            leading: const Icon(Icons.image),
            title: Text('Set Cover Image'),
          ),
          ListTile(
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              _deleteConfirm(video);
            },
            leading: const Icon(Icons.delete_forever),
            title: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Video Form'),
        actions: [
          IconButton(
            onPressed: _showAddMenu,
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: VideoListPage(
        onClick: _showOptionMenu,
      ),
    );
  }
}
