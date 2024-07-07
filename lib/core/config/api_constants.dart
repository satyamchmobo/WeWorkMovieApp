/// This class contains constant values used for API interaction.
class ApiConstants {
  /// The base URL for image assets on TMDb.
  static const String baseUrlImage = 'https://image.tmdb.org/t/p/w500';

  /// The URL for a placeholder image to display when an image is not found.
  static const String imageUrlForNotFound =
      'https://lascrucesfilmfest.com/wp-content/uploads/2018/01/no-poster-available.jpg';

  /// The base URL for movie data on TMDb.
  static const String baseUrl = 'https://api.themoviedb.org/3/movie';

  /// The URL for fetching now playing movies with English (US) language and pagination.
  static const String nowPlayingUrl =
      '$baseUrl/now_playing?language=en-US&page=';

  /// The URL for fetching top rated movies with English (US) language and pagination.
  static const String topRatedUrl = '$baseUrl/top_rated?language=en-US&page=';
}
