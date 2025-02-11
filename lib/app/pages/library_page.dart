import 'package:flutter/material.dart';
import 'package:movie_collections/app/widgets/my_scaffold.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {}

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Text('genres'),
    );
  }
}
