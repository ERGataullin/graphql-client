import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/data/models/movie_details.dart';
import '/data/services/movie.dart';

class MovieDetailsView extends StatefulWidget {
  const MovieDetailsView({super.key, required this.id});

  final int id;

  @override
  State<MovieDetailsView> createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<MovieDetailsView> {
  late final MovieService _service;
  bool _showLoader = false;
  MovieDetails? _movie;

  @override
  void initState() {
    super.initState();
    _service = context.read();
    _loadMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_movie?.title ?? ''),
      ),
      body: _showLoader
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: _movie!
                    .toJson()
                    .entries
                    .map((entry) => TableRow(children: [
                          Text(
                            entry.key,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(
                            entry.value.toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ]))
                    .toList(growable: false),
              ),
            ),
    );
  }

  Future<void> _loadMovie() async {
    setState(() {
      _showLoader = true;
    });

    final MovieDetails movie = await _service.getMovie(widget.id);

    setState(() {
      _showLoader = false;
      _movie = movie;
    });
  }
}
