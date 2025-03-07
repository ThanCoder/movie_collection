import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/movie_list_item.dart';
import 'package:movie_collections/app/components/path_chooser_modal_bottom_sheet.dart';
import 'package:movie_collections/app/components/series_list_item.dart';
import 'package:movie_collections/app/enums/movie_types.dart';
import 'package:movie_collections/app/models/movie_model.dart';
import 'package:movie_collections/app/models/series_model.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/services/movie_series_services.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

class MovieFormVideoPage extends StatefulWidget {
  const MovieFormVideoPage({super.key});

  @override
  State<MovieFormVideoPage> createState() => _MovieFormVideoPageState();
}

class _MovieFormVideoPageState extends State<MovieFormVideoPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  List<SeriesModel> seriesList = [];

  void init() async {
    final movie = context.read<MovieProvider>().getCurrent!;
    final res = await MovieSeriesServices.instance.getList(movie);
    if (res.isNotEmpty) {
      setState(() {
        seriesList = res;
      });
    }
  }

  Widget _getMovieWidget(MovieModel movie) {
    if (movie.type == MovieTypes.series.name) {
      return ListView.builder(
        itemCount: seriesList.length,
        itemBuilder: (context, index) => SeriesListItem(
          series: seriesList[index],
          onClicked: (series) {},
        ),
      );
    }
    return MovieListItem(
      movie: movie,
      onClicked: (movie, itemHeight) {},
    );
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => PathChooserModalBottomSheet(
        extensions: ['.mp4', '.mkv'],
        mimeTypes: ['video/mp4'],
        onPathChoosed: (path) {},
        onFileSelectorChoosed: (pathList) {
          print(pathList);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final isLoading = provider.isLoading;
    final movie = provider.getCurrent!;
    return MyScaffold(
      appBar: AppBar(
        title: Text('Video Form'),
      ),
      body: isLoading ? TLoader() : _getMovieWidget(movie),
      floatingActionButton: movie.type == MovieTypes.series.name
          ? FloatingActionButton(
              onPressed: _showMenu,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
