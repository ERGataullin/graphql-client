import 'package:flutter/material.dart';

import '/presentation/home/components/directors.dart';
import '/presentation/home/components/movies.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _page,
        children: const [
          MoviesView(),
          DirectorsView(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _page,
        onDestinationSelected: _onPageSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Directors',
          ),
        ],
      ),
    );
  }

  void _onPageSelected(int page) {
    setState(() {
      _page = page;
    });
  }
}
