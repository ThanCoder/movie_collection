import 'package:flutter/material.dart';
import 'package:mc_v2/app/components/app_components.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:real_path_file_selector/ui/widgets/core/index.dart';
import 'package:t_widgets/dialogs/t_confirm_dialog.dart';

class DeleteAction extends StatefulWidget {
  const DeleteAction({super.key});

  @override
  State<DeleteAction> createState() => _DeleteActionState();
}

class _DeleteActionState extends State<DeleteAction> {
  void _deleteConfirm() {
    showDialog(
      context: context,
      builder: (ctx) => TConfirmDialog(
        contentText:
            '`Not Exists Video Files `\nတွေအားလုံးကို ဖျက်ချင်တာ သေချာပြီလား?',
        submitText: 'Delete',
        onSubmit: () async {
          final notExitsList = VideoItem.getList(isExistsFile: false);
          for (var video in notExitsList) {
            await video.delete();
          }
          if (!ctx.mounted) return;
          showMessage(ctx, 'Deleted');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        Text('Delete Options'),
        ListTileWithDesc(
          title: 'Delete Not Exists Video',
          desc: 'Video မရှိရင် ဖျက်မယ်',
          onClick: _deleteConfirm,
        ),
      ],
    );
  }
}
