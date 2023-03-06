import 'package:graphql_flutter/graphql_flutter.dart';

import '/data/models/date_range.dart';
import '/data/models/movie_details.dart';
import '/data/models/movie_field.dart';
import '/data/models/movie_preview.dart';

abstract class MovieService {
  Future<List<MoviePreview>> getMovies({
    int? page,
    int? limit,
    DateRange? releaseDate,
    MovieField? orderBy,
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
    DateRange? releaseDate,
    MovieField? orderBy,
  }) {
    final String? pageArgument = page == null ? null : 'page: $page';
    final String? limitArgument = limit == null ? null : 'limit: $limit';
    final String? releaseDateArgument = releaseDate == null
        ? null
        : [
            'release_date: ',
            '{',
            [
              if (releaseDate.from != null)
                'from: "${releaseDate.from!.toIso8601String()}"',
              if (releaseDate.to != null)
                'to: "${releaseDate.to!.toIso8601String()}"',
            ].join(', '),
            '}',
          ].join();
    final String? orderByArgument =
        orderBy == null ? null : 'order_by: ${orderBy.value}';

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
