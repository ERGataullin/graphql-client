import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_client/data/models/date_range.dart';
import 'package:provider/provider.dart';

import '/data/models/movie_field.dart';
import '/data/models/movie_preview.dart';
import '/data/services/movie.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  late final MovieService _service;
  bool _showLoader = false;
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
        title: const Text('Top 20 movies of 1954'),
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

    final List<MoviePreview> movies = await _service.getMovies(
      limit: 20,
      releaseDate: DateRange(
        from: DateTime(1954, 1, 1),
        to: DateTime(1954, 12, 31),
      ),
      orderBy: MovieField.voteAverage,
    );

    setState(() {
      _showLoader = false;
      _movies = movies;
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
