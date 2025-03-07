import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:movie_collections/app/dialogs/core/index.dart';

class PathChooserModalBottomSheet extends StatefulWidget {
  void Function(String path) onPathChoosed;
  void Function(List<String> pathList) onFileSelectorChoosed;
  List<String>? extensions;
  List<String>? mimeTypes;
  PathChooserModalBottomSheet({
    super.key,
    required this.onPathChoosed,
    required this.onFileSelectorChoosed,
    this.extensions,
    this.mimeTypes,
  });

  @override
  State<PathChooserModalBottomSheet> createState() =>
      _PathChooserModalBottomSheetState();
}

class _PathChooserModalBottomSheetState
    extends State<PathChooserModalBottomSheet> {
  void _choosePath() {
    showDialog(
      context: context,
      builder: (context) => RenameDialog(
        title: 'Path ထည့်ပေးပါ',
        onCancel: () {},
        onSubmit: (path) {
          widget.onPathChoosed(path);
        },
      ),
    );
  }

  void _openChooser() async {
    try {
      final files = await openFiles(
        acceptedTypeGroups: [
          XTypeGroup(
            extensions: widget.extensions,
            mimeTypes: widget.mimeTypes,
          ),
        ],
      );

      if (files.isEmpty) return;

      List<String> pathList = files.map((f) => f.path).toList();

      ///choose type
      widget.onFileSelectorChoosed(pathList);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 200),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add From Path'),
              onTap: () {
                Navigator.pop(context);
                _choosePath();
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add From Selector'),
              onTap: () {
                Navigator.pop(context);
                _openChooser();
              },
            ),
          ],
        ),
      ),
    );
  }
}
