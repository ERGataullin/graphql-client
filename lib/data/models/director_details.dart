import '/data/models/director.dart';
import '/data/models/movie_preview.dart';

class DirectorDetails {
  const DirectorDetails({required this.director, this.movies = const []});

  final Director director;
  final List<MoviePreview> movies;
}
