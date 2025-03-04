import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/movie_add_action_button.dart';
import 'package:movie_collections/app/components/movie_info_type_chooser.dart';
import 'package:movie_collections/app/enums/index.dart';
import 'package:movie_collections/app/providers/index.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  void init() {
    context.read<MovieProvider>().initList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final list = provider.getList;
    final isLoading = provider.isLoading;

    print(list);

    return MyScaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          MovieAddActionButton(),
        ],
      ),
      body: isLoading
          ? TLoader()
          : MovieInfoTypeChooser(
              type: MovieInfoTypes.info,
              onChoosed: (type) {
                print(type);
              },
            ),
    );
  }
}
