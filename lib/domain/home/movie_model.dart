class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final String language;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.language,
  });
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      voteAverage: json['vote_average'].toDouble(),
      voteCount: json['vote_count'],
      popularity: json['popularity'].toDouble(),
      language: json['original_language'],
    );
  }
}
