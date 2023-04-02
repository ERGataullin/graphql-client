import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/data/models/movie_preview.dart';
import '/data/models/movies_filter.dart';
import '/data/services/movie.dart';
import '/presentation/home/components/movies_filter.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  late final MovieService _service;
  bool _showLoader = false;
  MoviesFilter _filter = const MoviesFilter();
  List<MoviePreview> _movies = const [];

  @override
  void initState() {
    super.initState();
    _service = context.read();
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _onFilterPressed,
          ),
        ],
      ),
      body: _showLoader
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (context, index) => _Movie(_movies[index]),
            ),
    );
  }

  Future<void> _loadMovies() async {
    setState(() {
      _showLoader = true;
    });

    final List<MoviePreview> movies =
        await _service.getMovies(limit: 20, filter: _filter);

    setState(() {
      _showLoader = false;
      _movies = movies;
    });
  }

  void _onFilterPressed() {
    showModalBottomSheet<MoviesFilter>(
      context: context,
      builder: (context) => MoviesFilterView(initial: _filter),
    ).then((filter) {
      _filter = filter!;
      _loadMovies();
    });
  }
}

class _Movie extends StatelessWidget {
  const _Movie(this.movie, {super.key});

  final MoviePreview movie;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(movie.title),
      onTap: () => context.push('/movies/${movie.id}'),
    );
  }
}
