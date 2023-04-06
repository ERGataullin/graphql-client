import '/data/models/date_range.dart';
import '/data/models/movie_field.dart';

class MoviesFilter {
  const MoviesFilter({
    this.releaseDate,
    this.orderBy,
    this.director,
  });

  final DateRange? releaseDate;
  final MovieField? orderBy;
  final int? director;

  MoviesFilter copyWith({
    DateRange? releaseDate,
    MovieField? orderBy,
    int? director,
  }) =>
      MoviesFilter(
        releaseDate: releaseDate ?? this.releaseDate,
        orderBy: orderBy ?? this.orderBy,
        director: director ?? this.director,
      );
}
