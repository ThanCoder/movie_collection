import 'package:flutter/material.dart';
import 'package:mc_v2/app/models/info_type.dart';

class InfoTypeChooser extends StatefulWidget {
  InfoType? value;
  void Function(InfoType value) onChoosed;
  InfoTypeChooser({
    super.key,
    this.value,
    required this.onChoosed,
  });

  @override
  State<InfoTypeChooser> createState() => _InfoTypeChooserState();
}

class _InfoTypeChooserState extends State<InfoTypeChooser> {
  late InfoType value;
  @override
  void initState() {
    value = widget.value ?? InfoType.info;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<InfoType>(
      padding: EdgeInsets.all(4),
      borderRadius: BorderRadius.circular(4),
      value: value,
      items: InfoType.values
          .map((e) => DropdownMenuItem<InfoType>(value: e, child: Text(e.name)))
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
