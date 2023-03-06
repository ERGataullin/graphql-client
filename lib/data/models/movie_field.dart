enum MovieField {
  id._('id'),
  originalTitle._('original_title'),
  budget._('budget'),
  popularity._('popularity'),
  releaseDate._('release_date'),
  revenue._('revenue'),
  title._('title'),
  voteAverage._('vote_average'),
  voteCount._('vote_count'),
  overview._('overview'),
  tagline._('tagline'),
  uid._('uid'),
  directorId._('director_id');

  const MovieField._(this.value);

  final String value;
}
