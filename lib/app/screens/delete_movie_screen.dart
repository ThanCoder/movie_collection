import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/providers/movie_provider.dart';
import 'package:movie_collections/app/utils/app_util.dart';
import 'package:movie_collections/app/widgets/my_scaffold.dart';
import 'package:movie_collections/app/widgets/t_loader.dart';
import 'package:provider/provider.dart';

class DeleteMovieScreen extends StatefulWidget {
  const DeleteMovieScreen({super.key});

  @override
  State<DeleteMovieScreen> createState() => _DeleteMovieScreenState();
}

class _DeleteMovieScreenState extends State<DeleteMovieScreen> {
  final ScrollController _scrollController = ScrollController();
  bool showSelect = true;
  bool isSelectedAll = false;
  bool isLoading = false;
  List<MovieModel> movieList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void init() {
    setState(() {
      isLoading = true;
    });
    context.read<MovieProvider>().initList(
      onDone: (list) {
        setState(() {
          isLoading = false;
          movieList = list;
        });
      },
    );
  }

  List<DataColumn> _getColumn() {
    return MovieModel.getFields()
        .map((title) => DataColumn(label: Text(title)))
        .toList();
  }

  List<DataRow> _getRows(List<MovieModel> list) {
    return list.asMap().entries.map((res) {
      final vd = res.value;
      return DataRow(cells: [
        DataCell(
          Checkbox(
            value: movieList[res.key].isSelected,
            onChanged: (value) {
              setState(() {
                movieList[res.key].isSelected = value!;
              });
            },
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Text(
              vd.id,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(Text(vd.title)),
        DataCell(Text(vd.imdb.toString())),
        DataCell(Text(vd.year.toString())),
        DataCell(Text(vd.isMultipleMovie.toString())),
        DataCell(Text(vd.durationInMinutes.toString())),
        DataCell(Text(getParseDate(vd.date))),
      ]);
    }).toList();
  }

  void _selectAll(bool isChecked) {
    final res = movieList.map((mv) {
      mv.isSelected = isChecked;
      return mv;
    }).toList();
    setState(() {
      movieList = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text('Delete Movie'),
      ),
      body: isLoading
          ? Center(child: TLoader())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Scrollbar(
                controller: _scrollController,
                thickness: 7.0, // Scrollbar thickness
                radius: Radius.circular(5.0), // Scrollbar radius
                thumbVisibility: true, // Always show scrollbar
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: IconButton(
                          onPressed: () {
                            isSelectedAll = !isSelectedAll;
                            _selectAll(isSelectedAll);
                          },
                          icon: Icon(Icons.select_all),
                        ),
                      ),
                      ..._getColumn()
                    ],
                    rows: _getRows(movieList),
                  ),
                ),
              ),
            ),
    );
  }
}
