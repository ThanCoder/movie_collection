import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/widgets/core/index.dart';

import '../utils/index.dart';

class SeriesListItem extends StatelessWidget {
  SeriesModel series;
  void Function(SeriesModel series) onClicked;
  SeriesListItem({
    super.key,
    required this.series,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClicked(series),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: MyImageFile(path: series.coverPath),
            ),
            Expanded(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(series.title),
                  Text(AppUtil.instance
                      .getParseFileSize(series.size.toDouble())),
                  Text(AppUtil.instance.getParseDate(series.date)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
