import 'package:flutter/material.dart';
import 'package:mc_v2/app/models/video_type.dart';
import 'package:than_pkg/than_pkg.dart';

class VideoTypeChooser extends StatefulWidget {
  VideoType? value;
  void Function(VideoType value) onChoosed;
  VideoTypeChooser({
    super.key,
    this.value,
    required this.onChoosed,
  });

  @override
  State<VideoTypeChooser> createState() => _VideoTypeChooserState();
}

class _VideoTypeChooserState extends State<VideoTypeChooser> {
  late VideoType value;
  @override
  void initState() {
    value = widget.value ?? VideoType.movie;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<VideoType>(
      padding: EdgeInsets.all(4),
      borderRadius: BorderRadius.circular(4),
      value: value,
      items: VideoType.getList
          .map((e) => DropdownMenuItem<VideoType>(
              value: e, child: Text(e.name.toCaptalize())))
          .toList(),
      onChanged: (value) {
        setState(() {
          this.value = value!;
        });
        widget.onChoosed(this.value);
      },
    );
  }
}
