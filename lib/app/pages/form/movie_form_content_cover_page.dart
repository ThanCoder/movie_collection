import 'package:flutter/material.dart';
import 'package:movie_collections/app/widgets/core/my_scaffold.dart';

class MovieFormContentCoverPage extends StatelessWidget {
  const MovieFormContentCoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Content Cover Form'),
      ),
      body: Text('Content Cover page'),
    );
  }
}
