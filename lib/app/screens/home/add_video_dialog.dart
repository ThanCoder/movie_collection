import 'package:flutter/material.dart';
import 'package:mc_v2/app/components/info_type_chooser.dart';
import 'package:mc_v2/app/components/video_type_chooser.dart';
import 'package:mc_v2/app/models/info_type.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/models/video_type.dart';

class AddVideoDialog extends StatefulWidget {
  List<VideoItem> list;
  void Function()? onRefersh;
  AddVideoDialog({
    super.key,
    required this.list,
    this.onRefersh,
  });

  @override
  State<AddVideoDialog> createState() => _AddVideoDialogState();
}

class _AddVideoDialogState extends State<AddVideoDialog> {
  VideoType videoType = VideoType.movie;
  InfoType infoType = InfoType.info;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text('Add Movies'),
      scrollable: true,
      content: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Video Types'),
          VideoTypeChooser(
            value: videoType,
            onChoosed: (value) {
              setState(() {
                videoType = value;
              });
            },
          ),
          Text('Info Types'),
          InfoTypeChooser(
            value: infoType,
            onChoosed: (value) {
              setState(() {
                infoType = value;
              });
            },
          ),
          const Divider(),
          Text('info -> video files info ပဲရယူခြင်း'),
          Text('realData -> video files ကိုပါ ရွှေ့(move) ပြောင်းခြင်း'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await VideoItem.addMultiple(
              widget.list,
              infoType: infoType,
              videoType: videoType,
            );
            if (widget.onRefersh != null) {
              widget.onRefersh!();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
