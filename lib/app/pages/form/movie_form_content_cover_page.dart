import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:movie_collections/app/components/content_cover_grid_item.dart';
import 'package:movie_collections/app/components/drop_filepath_container.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/services/movie_content_cover_serices.dart';
import 'package:movie_collections/app/widgets/core/index.dart';
import 'package:provider/provider.dart';

class MovieFormContentCoverPage extends StatefulWidget {
  const MovieFormContentCoverPage({super.key});

  @override
  State<MovieFormContentCoverPage> createState() =>
      _MovieFormContentCoverPageState();
}

class _MovieFormContentCoverPageState extends State<MovieFormContentCoverPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  List<String> list = [];
  bool isLoading = false;

  void init() async {
    try {
      setState(() {
        isLoading = true;
      });
      list = await MovieContentCoverSerices.instance
          .getList(context.read<MovieProvider>().getCurrent!.id);

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addCover(List<DropItem> items) async {
    try {
      final list = items
          .where(
              (item) => (lookupMimeType(item.path) ?? '').startsWith('image'))
          .map((item) => item.path)
          .toList();
      await MovieContentCoverSerices.instance.add(
        movieId: context.read<MovieProvider>().getCurrent!.id,
        pathList: list,
      );
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _addFromPath() async {
    try {
      setState(() {
        isLoading = true;
      });
      final files = await openFiles(
        acceptedTypeGroups: [
          XTypeGroup(mimeTypes: [
            'image/png',
            'image/jpg',
            'image/webp',
            'image/jpeg'
          ]),
        ],
      );
      final list = files
          .where((file) =>
              File(file.path).statSync().type == FileSystemEntityType.file)
          .map((file) => file.path)
          .toList();

      if (!mounted) return;
      await MovieContentCoverSerices.instance.add(
        movieId: context.read<MovieProvider>().getCurrent!.id,
        pathList: list,
      );
      if (!mounted) return;
      init();
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieId = context.watch<MovieProvider>().getCurrent!.id;
    return MyScaffold(
      appBar: AppBar(
        title: Text('Content Cover'),
        actions: [
          IconButton(
            onPressed: _addFromPath,
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),
      body: DropFilepathContainer(
        onDroped: _addCover,
        child: isLoading
            ? TLoader()
            : list.isEmpty
                ? Center(child: Text('Drop Here...'))
                : RefreshIndicator(
                    onRefresh: () async {
                      init();
                    },
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 180,
                        mainAxisExtent: 200,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) => ContentCoverGridItem(
                        index: index,
                        path: MovieContentCoverSerices.getImagePath(
                            movieId, list[index]),
                        onDeleted: (index, path) async {
                          try {
                            list.removeAt(index);
                            await MovieContentCoverSerices.instance
                                .remove(movieId: movieId, index: index);
                            setState(() {});
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                      ),
                    ),
                  ),
      ),
    );
  }
}
