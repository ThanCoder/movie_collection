import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class DropFilepathContainer extends StatelessWidget {
  void Function(List<DropItem> items)? onDroped;
  Widget child;
  DropFilepathContainer({
    super.key,
    required this.onDroped,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      enable: false,
      onDragDone: onDroped != null
          ? (details) {
              onDroped!(details.files);
            }
          : null,
      child: child,
    );
  }
}
