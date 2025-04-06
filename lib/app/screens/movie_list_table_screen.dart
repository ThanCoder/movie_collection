import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_collections/app/dialogs/core/confirm_dialog.dart';
import 'package:movie_collections/app/extensions/datetime_extenstion.dart';
import 'package:movie_collections/app/extensions/double_extension.dart';
import 'package:movie_collections/app/models/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/widgets/core/index.dart';
import 'package:provider/provider.dart';

class MovieListTableScreen extends StatefulWidget {
  const MovieListTableScreen({super.key});

  @override
  State<MovieListTableScreen> createState() => _MovieListTableScreenState();
}

class _MovieListTableScreenState extends State<MovieListTableScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();
  List<MovieModel> list = [];
  bool isLoading = false;
  bool selectAllCheckBox = false;

  void init() async {
    setState(() {
      isLoading = true;
    });
    list = MovieProvider.getDB.values.toList();
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
    _selectAll(false);
  }

  List<DataColumn> _getHeader() {
    return MovieModel.getDataColumnHeaderList()
        .map(
          (name) => DataColumn(
            columnWidth: name == 'Title' ? _HeaderWidth(max: 300) : null,
            label: Text(name),
          ),
        )
        .toList();
  }

  List<DataRow> _getDataList() {
    return list
        .map(
          (mv) => DataRow(
            onLongPress: () {
              _select(true, mv);
              _showMenu();
            },
            cells: [
              DataCell(
                Checkbox(
                  value: mv.isSelected,
                  onChanged: (value) {
                    _select(value!, mv);
                  },
                ),
              ),
              DataCell(
                Text(mv.title),
              ),
              DataCell(
                Text(mv.type),
              ),
              DataCell(
                Text(mv.infoType),
              ),
              DataCell(
                Text(mv.size.toDouble().toFileSizeLabel()),
              ),
              DataCell(
                Text(mv.ext),
              ),
              DataCell(
                Text(
                    DateTime.fromMillisecondsSinceEpoch(mv.date).toParseTime()),
              ),
            ],
          ),
        )
        .toList();
  }

  int _getSelectedCount() {
    return list.where((mv) => mv.isSelected).length;
  }

  void _showMenu() {
    final names =
        list.where((mv) => mv.isSelected).map((mv) => mv.title).toSet();
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              Text(
                names.join('\n'),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
              Text('Selected Count: ${names.length}'),
              ListTile(
                iconColor: Colors.red,
                leading: Icon(Icons.delete_forever),
                title: Text('Deleted'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteConfirm();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteConfirm() {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        contentText: 'သင်ဖျက်ချင်တာ သေချာပြီလား?',
        onCancel: () {},
        onSubmit: () async {
          final deleteList = list.where((mv) => mv.isSelected).toList();
          await context.read<MovieProvider>().deleteMultiple(deleteList);
          if (!mounted) return;
          init();
        },
      ),
    );
  }

  void _select(bool isChecked, MovieModel movie) {
    list = list.map((mv) {
      if (mv.title == movie.title) {
        mv.isSelected = isChecked;
      }
      return mv;
    }).toList();

    setState(() {});
  }

  void _selectAll(bool isChecked) {
    list = list.map((mv) {
      mv.isSelected = isChecked;
      return mv;
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      contentPadding: 0,
      appBar: AppBar(
        title: Text('Movie List'),
        actions: [
          Platform.isLinux
              ? IconButton(
                  onPressed: init,
                  icon: Icon(Icons.refresh),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          init();
        },
        child: Scrollbar(
          // 👉 vertical scrollbar
          controller: _verticalController,
          thumbVisibility: true,
          trackVisibility: true,
          interactive: true,
          scrollbarOrientation: ScrollbarOrientation.right,
          child: Scrollbar(
            // 👉 horizontal scrollbar (wrap outer scroll view)
            controller: _horizontalController,
            thumbVisibility: true,
            trackVisibility: true,
            interactive: true,
            thickness: 10,
            scrollbarOrientation: ScrollbarOrientation.bottom,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                controller: _verticalController,
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(
                      // columnWidth: _HeaderWidth(max: 50),
                      label: Row(
                        children: [
                          Checkbox(
                            value: selectAllCheckBox,
                            onChanged: (value) {
                              setState(() {
                                selectAllCheckBox = value!;
                              });
                              _selectAll(value!);
                            },
                          ),
                          Text(
                              '${_getSelectedCount() == 0 ? '' : _getSelectedCount()}'),
                        ],
                      ),
                    ),
                    ..._getHeader()
                  ],
                  rows: _getDataList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderWidth extends TableColumnWidth {
  double min;
  double max;

  // ignore: unused_element_parameter
  _HeaderWidth({this.min = 50, this.max = 400});
  @override
  double maxIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    return max;
  }

  @override
  double minIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    return min;
  }
}
