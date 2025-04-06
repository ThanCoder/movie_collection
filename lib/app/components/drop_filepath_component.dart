import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class DropFilepathComponent extends StatelessWidget {
  void Function(List<DropItem> pathList) onDroped;
  double? containerSize;
  Color color;
  String title;
  DropFilepathComponent({
    super.key,
    required this.onDroped,
    this.containerSize,
    this.title = 'Drop Here...',
    this.color = const Color.fromARGB(255, 17, 71, 116),
  });

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (details) {
        List<DropItem> list = [];
        for (var file in details.files) {
          list.add(file);
        }
        onDroped(list);
      },
      child: Container(
        width: containerSize,
        height: containerSize,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
