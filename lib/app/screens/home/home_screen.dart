import 'package:flutter/material.dart';
import 'package:mc_v2/app/screens/home/home_page.dart';
import 'package:mc_v2/app/screens/home/more_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            icon: Icon(Icons.home),
          ),
          Tab(
            icon: Icon(Icons.grid_view_rounded),
          ),
        ]),
      ),
    );
  }
}
