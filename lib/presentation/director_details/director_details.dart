import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/data/models/director_details.dart';
import '/data/models/director.dart';
import '/data/models/movie_preview.dart';
import '/data/services/movie.dart';

class DirectorDetailsView extends StatefulWidget {
  const DirectorDetailsView({super.key, required this.id});

  final int id;

  @override
  State<DirectorDetailsView> createState() => _DirectorDetailsViewState();
}

class _DirectorDetailsViewState extends State<DirectorDetailsView> {
  late final MovieService _service;
  bool _showLoader = false;
  Director? _director;
  List<MoviePreview> _movies = const [];

  @override
  void initState() {
    super.initState();
    _service = context.read();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_director?.name ?? ''),
      ),
      body: _showLoader
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 16),
                _buildFields(context),
                const SizedBox(height: 16),
                _buildMovies(context),
                const SizedBox(height: 16),
              ],
            ),
    );
  }

  Widget _buildFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: _director!
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
    );
  }

  Widget _buildMovies(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Movies',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ..._movies
            .map((movie) => ListTile(
                  title: Text(movie.title),
                  onTap: () => context.push('/movies/${movie.id}'),
                ))
            .toList(growable: false),
      ],
    );
  }

  Future<void> _load() async {
    setState(() {
      _showLoader = true;
    });

    final DirectorDetails details = await _service.getDirector(widget.id);

    setState(() {
      _showLoader = false;
      _director = details.director;
      _movies = details.movies;
    });
  }
}
