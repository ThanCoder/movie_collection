import 'package:flutter/material.dart';
import 'package:mc_v2/models/video_item.dart';

class AddVideoDialog extends StatelessWidget {
  List<VideoItem> list;
  void Function()? onRefersh;
  AddVideoDialog({
    super.key,
    required this.list,
    this.onRefersh,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      content: Column(
        children: [
          Text('Add Movie'),
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
            await VideoItem.addMultiple(list);
            if (onRefersh != null) {
              onRefersh!();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
