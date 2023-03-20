import 'package:graphql_flutter/graphql_flutter.dart';

import '/data/models/movie_details.dart';
import '/data/models/movie_field.dart';
import '/data/models/movie_preview.dart';
import '/data/models/movies_filter.dart';

abstract class MovieService {
  Future<List<MoviePreview>> getMovies({
    int? page,
    int? limit,
    required MoviesFilter filter,
  });

  Future<MovieDetails> getMovie(int id);
}

class GraphQlMovieService implements MovieService {
  GraphQlMovieService(this._client);

  final GraphQLClient _client;

  @override
  Future<List<MoviePreview>> getMovies({
    int? page,
    int? limit,
    required MoviesFilter filter,
  }) {
    final String? pageArgument = page == null ? null : 'page: $page';
    final String? limitArgument = limit == null ? null : 'limit: $limit';
    final String? releaseDateArgument = filter.releaseDate == null
        ? null
        : [
            'release_date: ',
            '{',
            [
              if (filter.releaseDate!.from != null)
                'from: "${filter.releaseDate!.from!.toIso8601String()}"',
              if (filter.releaseDate!.to != null)
                'to: "${filter.releaseDate!.to!.toIso8601String()}"',
            ].join(', '),
            '}',
          ].join();
    final String? orderByArgument =
        filter.orderBy == null ? null : 'order_by: ${filter.orderBy!.value}';

    final String arguments = [
      pageArgument,
      limitArgument,
      releaseDateArgument,
      orderByArgument
    ].whereType<String>().join(', ');

    final String fields = [
      MovieField.id,
      MovieField.title,
    ].map((field) => field.value).join(' ');

    final String query = '{movies($arguments) {$fields}}';

    return _client
        .query(QueryOptions(document: gql(query)))
        .then((result) => result.data?['movies'] ?? const [])
        .then((jsons) => jsons
            .map<MoviePreview>((json) => MoviePreview.fromJson(json))
            .toList(growable: false));
  }

  @override
  Future<MovieDetails> getMovie(int id) {
    final String query = '''{ 
      movie(id: $id) {
        id
        original_title
        budget
        popularity
        release_date
        revenue
        title
        vote_average
        vote_count
        overview
        tagline
        uid
        director_id
      }
    }''';

    return _client
        .query(QueryOptions(document: gql(query)))
        .then((result) => MovieDetails.fromJson(result.data!['movie']));
  }
}
