import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mc_v2/app/models/season.dart';
import 'package:t_widgets/widgets/index.dart';

class SeasonChooserDialog extends StatefulWidget {
  List<Season> list;
  void Function(Season season, int startEp) onChoosed;
  SeasonChooserDialog({
    super.key,
    required this.list,
    required this.onChoosed,
  });

  @override
  State<SeasonChooserDialog> createState() => _SeasonChooserDialogState();
}

class _SeasonChooserDialogState extends State<SeasonChooserDialog> {
  Season? current;
  final epController = TextEditingController();

  String? error;

  @override
  void initState() {
    current = widget.list.isEmpty ? null : widget.list.first;
    epController.text = '1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          // start ep
          TTextField(
            label: Text('Start Episode'),
            controller: epController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputType: TextInputType.number,
            errorText: error,
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  error = 'value is empty';
                });
                return;
              }
              if (int.tryParse(value) == null) {
                setState(() {
                  error = 'number is required!';
                });
                return;
              }
              setState(() {
                error = null;
              });
            },
          ),
          Text('Choose Season'),
          DropdownButton<Season>(
            padding: const EdgeInsets.all(4),
            borderRadius: BorderRadius.circular(3),
            value: current,
            items: widget.list
                .map((e) => DropdownMenuItem<Season>(
                    value: e, child: Text('S${e.seasonNumber}')))
                .toList(),
            onChanged: (value) {
              current = value;
              setState(() {});
            },
          ),
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
          onPressed: current == null
              ? null
              : () {
                  Navigator.pop(context);
                  widget.onChoosed(current!, int.parse(epController.text));
                },
          child: Text('Choose'),
        ),
      ],
    );
  }
}
