import 'package:flutter/material.dart';
import 'package:movie_collections/app/dialogs/tag_form_dialog.dart';

class TagListChooser extends StatefulWidget {
  String tags;
  void Function(String value) onChanged;
  TagListChooser({
    super.key,
    required this.tags,
    required this.onChanged,
  });

  @override
  State<TagListChooser> createState() => _TagListChooserState();
}

class _TagListChooserState extends State<TagListChooser> {
  List<String> _getList() {
    return widget.tags.split(',').where((name) => name.isNotEmpty).toList();
  }

  List<Widget> _getWidgetList() {
    return List.generate(
      _getList().length,
      (index) {
        final name = _getList()[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.all(5),
          child: Text(
            '#$name',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  void _showTags() {
    showDialog(
      context: context,
      builder: (context) => TagFormDialog(
        values: widget.tags,
        onSubmited: widget.onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: [
        ..._getWidgetList(),
        IconButton(
          color: Colors.green[600],
          onPressed: _showTags,
          icon: Icon(Icons.add_circle),
        ),
      ],
    );
  }
}
