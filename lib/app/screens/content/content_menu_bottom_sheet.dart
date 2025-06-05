import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mc_v2/app/components/app_components.dart';
import 'package:mc_v2/app/models/info_type.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/route_helper.dart';
import 'package:mc_v2/app/screens/content/my_listener/content_screen_event_listener.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class ContentMenuBottomSheet extends StatefulWidget {
  VideoItem video;
  void Function()? onBackpress;
  ContentMenuBottomSheet({
    super.key,
    required this.video,
    this.onBackpress,
  });

  @override
  State<ContentMenuBottomSheet> createState() => _ContentMenuBottomSheetState();
}

class _ContentMenuBottomSheetState extends State<ContentMenuBottomSheet> {
  void _deleteConfirm() {
    showCupertinoDialog(
      context: context,
      builder: (context) => TConfirmDialog(
        contentText: '`${widget.video.title}` ကိုဖျက်ချင်တာ သေချာပြီလား?',
        submitText: 'ဖျက်မယ်',
        onSubmit: () async {
          showMessage(context, 'ဖျက်နေပါပြီ...', oldStyle: true);
          await widget.video.delete();
          if (widget.onBackpress != null) {
            widget.onBackpress!();
          }
        },
      ),
    );
  }

  void _restoreConfirm() {
    showCupertinoDialog(
      context: context,
      builder: (context) => TConfirmDialog(
        contentText:
            '`${widget.video.title}` ကို Restore လုပ်ချင်တာ သေချာပြီလား?',
        submitText: 'Restore',
        onSubmit: () async {
          // showMessage(context, 'ဖျက်နေပါပြီ...', oldStyle: true);
          await widget.video.restore();
          if (widget.onBackpress != null) {
            widget.onBackpress!();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.open_in_new),
            title: Text('Open With Another'),
            onTap: () async {
              Navigator.pop(context);
              ContentScreenEventSender.instance.changeCoverAndPlayer(false);
              await ThanPkg.platform.launch(widget.video.filePath);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              goFormScreen(context, widget.video);
            },
          ),
          widget.video.infoType == InfoType.realData
              ? ListTile(
                  iconColor: Colors.yellow,
                  leading: Icon(Icons.restore),
                  title: Text('Restore'),
                  onTap: () {
                    Navigator.pop(context);
                    _restoreConfirm();
                  },
                )
              : SizedBox.shrink(),
          ListTile(
            iconColor: Colors.red,
            leading: Icon(Icons.delete),
            title: Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              _deleteConfirm();
            },
          ),
        ],
      ),
    );
  }
}
