import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/data/models/director.dart';
import '/data/services/movie.dart';

class DirectorsView extends StatefulWidget {
  const DirectorsView({super.key});

  @override
  State<DirectorsView> createState() => _DirectorsViewState();
}

class _DirectorsViewState extends State<DirectorsView> {
  late final MovieService _service;
  bool _showLoader = false;
  List<Director> _directors = const [];

  @override
  void initState() {
    super.initState();
    _service = context.read();
    _loadDirectors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directors'),
      ),
      body: _showLoader
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _directors.length,
              itemBuilder: (context, index) => _Director(_directors[index]),
            ),
    );
  }

  Future<void> _loadDirectors() async {
    setState(() {
      _showLoader = true;
    });

    final List<Director> directors = await _service.getDirectors();

    setState(() {
      _showLoader = false;
      _directors = directors;
    });
  }
}

class _Director extends StatelessWidget {
  const _Director(this.director, {super.key});

  final Director director;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(director.name),
      onTap: () => context.push('/directors/${director.id}'),
    );
  }
}
