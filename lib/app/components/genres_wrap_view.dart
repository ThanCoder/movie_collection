import 'package:flutter/material.dart';
import 'package:real_path_file_selector/ui/extensions/string_extension.dart';

class GenresWrapView extends StatelessWidget {
  String genres;
  void Function(String genres) onClicked;
  String title;
  GenresWrapView({
    super.key,
    required this.genres,
    required this.onClicked,
    this.title = 'Genres',
  });
  List<Widget> _getList() {
    var list = genres.split(',');
    list = list.where((name) => name.isNotEmpty).toList();
    return list.map((name) => _getItem(name)).toList();
  }

  Widget _getItem(String name) {
    return GestureDetector(
      onTap: () => onClicked(name),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color.fromARGB(197, 51, 48, 48),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(name.toCaptalize()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: _getList(),
        ),
      ],
    );
  }
}
