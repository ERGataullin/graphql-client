class MovieDetails {
  const MovieDetails({
    required this.id,
    required this.originalTitle,
    required this.budget,
    required this.popularity,
    required this.releaseDate,
    required this.revenue,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
    this.overview,
    this.tagline,
    required this.uid,
    required this.directorId,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) => MovieDetails(
        id: json['id'],
        originalTitle: json['original_title'],
        budget: json['budget'],
        popularity: json['popularity'],
        releaseDate: DateTime.parse(json['release_date']),
        revenue: json['revenue'],
        title: json['title'],
        voteAverage: json['vote_average'],
        voteCount: json['vote_count'],
        overview: json['overview'],
        tagline: json['tagline'],
        uid: json['uid'],
        directorId: json['director_id'],
      );

  final int id;
  final String originalTitle;
  final int budget;
  final int popularity;
  final DateTime releaseDate;
  final int revenue;
  final String title;
  final double voteAverage;
  final int voteCount;
  final String? overview;
  final String? tagline;
  final int uid;
  final int directorId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'original_title': originalTitle,
        'budget': budget,
        'popularity': popularity,
        'release_date': releaseDate.toString(),
        'revenue': revenue,
        'title': title,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'overview': overview,
        'tagline': tagline,
        'uid': uid,
        'director_id': directorId,
      };
}
