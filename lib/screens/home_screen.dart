import 'package:flutter/material.dart';
import 'package:mc_v2/pages/home_page.dart';
import 'package:mc_v2/pages/more_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // appBar: AppBar(),
        body: TabBarView(
          children: [
            HomePage(),
            MorePage(),
          ],
        ),

        bottomNavigationBar: TabBar(tabs: [
          Tab(
            text: 'Home',
            icon: Icon(Icons.home),
          ),
          Tab(
            text: 'More',
            icon: Icon(Icons.grid_view_rounded),
          ),
        ]),
      ),
    );
  }
}
