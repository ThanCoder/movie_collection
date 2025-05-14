import 'package:flutter/material.dart';
import 'package:mc_v2/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: Text('home page'),
    );
  }
}
