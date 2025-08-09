class Movie {
  final String id;
  final String title;
  final String? overview;
  final String? posterUrl;

  Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterUrl,
  });
}