import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_work/core/config/api_constants.dart';
import 'package:we_work/core/config/shared_preference_constants.dart';
import 'package:we_work/domain/home/movie_model.dart';
import 'package:we_work/domain/home/movies_repository_service.dart';
import 'package:we_work/core/services/service_locator.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  @override
  Future<List<Movie>> getNowPlayingMovies(int page) async {
    final String? dataCached = sharedPreferencesService
        .getString(SharedPrefrenceConstants.cacheNowPlayingKey);
    if (dataCached != null && page == 1) {
      final List<Movie> listOfCachedMovies =
          (json.decode(dataCached)['results'] as List)
              .map((item) => Movie.fromJson(item))
              .toList();
      return listOfCachedMovies;
    } else {
      return getMoviesStoreInCache(
          page,
          SharedPrefrenceConstants.cacheNowPlayingKey,
          ApiConstants.nowPlayingUrl);
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies(int page) async {
    final String? dataCached = sharedPreferencesService
        .getString(SharedPrefrenceConstants.cacheTopRatedKey);

    if (dataCached != null && page == 1) {
      final List<Movie> listOfCachedMovies =
          (json.decode(dataCached)['results'] as List)
              .map((item) => Movie.fromJson(item))
              .toList();
      return listOfCachedMovies;
    } else {
      return getMoviesStoreInCache(page,
          SharedPrefrenceConstants.cacheTopRatedKey, ApiConstants.topRatedUrl);
    }
  }

  Future<List<Movie>> getMoviesStoreInCache(
      int page, String cacheKey, String url) async {
    // String? token = await authService.fetchToken();
    try {
      final response = await http.get(
        Uri.parse('$url$page'),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YTg3ZTY4MDMyODIwMTIzZmQ0Yzg0YjQzNDhjYjc3ZCIsInN1YiI6IjY2Mjg5NDExOTFmMGVhMDE0YjAwOWU1ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6zIM73Giwg5M4wP6MX8KDCpee7IMnpnLTZUyMpETb08',
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<Movie> movies =
            (json.decode(response.body)['results'] as List)
                .map((item) => Movie.fromJson(item))
                .toList();

        if (page == 1) {
          _cacheMovies(response.body, cacheKey);
        }

        return movies;
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }

  Future<void> _cacheMovies(String data, String cacheKey) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(cacheKey, data);
    } catch (e) {
      throw Exception('Failed to cache movies: $e');
    }
  }
}
