import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/extensions/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:movie_collections/app/screens/movie_player_screen.dart';
import 'package:movie_collections/app/utils/index.dart';
import 'package:movie_collections/app/widgets/index.dart';
import 'package:provider/provider.dart';

class MovieContentScreen extends StatelessWidget {
  const MovieContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final movie = provider.getCurrent;
    final isLoading = provider.isLoading;
    if (isLoading) {
      return TLoader();
    }
    return MyScaffold(
      appBar: AppBar(
        title: Text(movie!.title),
        actions: [
          MovieContentActionButton(
            onDoned: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: isLoading
          ? TLoader()
          : SingleChildScrollView(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //header
                  Row(
                    spacing: 10,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: MyImageFile(
                          path: movie.coverPath,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title),
                            Text(movie.type.toCaptalize()),
                            Text(movie.infoType.toCaptalize()),
                            Text(movie.tags),
                            Text(AppUtil.instance
                                .getParseFileSize(movie.size.toDouble())),
                            Text(AppUtil.instance.getParseDate(movie.date)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //watch btn
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoviePlayerScreen(),
                        ),
                      );
                    },
                    child: Text('Watch Movie'),
                  ),
                  //desc
                  SelectableText(movie.content),
                ],
              ),
            ),
    );
  }
}
