class MoviePreview {
  const MoviePreview({
    required this.id,
    required this.title,
  });

  factory MoviePreview.fromJson(Map<String, dynamic> json) => MoviePreview(
        id: json['id'],
        title: json['title'],
      );

  final int id;
  final String title;
}
