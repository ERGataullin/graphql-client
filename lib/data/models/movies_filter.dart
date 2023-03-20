import '/data/models/date_range.dart';
import '/data/models/movie_field.dart';

class MoviesFilter {
  const MoviesFilter({this.releaseDate, this.orderBy});

  final DateRange? releaseDate;
  final MovieField? orderBy;

  MoviesFilter copyWith({
    DateRange? releaseDate,
    MovieField? orderBy,
  }) =>
      MoviesFilter(
        releaseDate: releaseDate ?? this.releaseDate,
        orderBy: orderBy ?? this.orderBy,
      );
}
