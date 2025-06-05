import 'package:flutter/material.dart';
import 'package:movie_collections/app/widgets/core/my_image_file.dart';

class ContentCoverGridItem extends StatelessWidget {
  int index;
  String path;
  void Function(int index, String path) onDeleted;
  ContentCoverGridItem({
    super.key,
    required this.index,
    required this.path,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 180,
          height: 200,
          child: MyImageFile(
            path: path,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          left: 10,
          top: 10,
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(151, 12, 12, 12),
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(2),
            child: Text(
              index.toString(),
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            color: const Color.fromARGB(255, 233, 39, 25),
            onPressed: () => onDeleted(index, path),
            icon: Icon(Icons.delete_forever_rounded),
          ),
        ),
      ],
    );
  }
}
