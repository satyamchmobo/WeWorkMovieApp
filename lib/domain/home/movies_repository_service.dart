import 'package:we_work/domain/home/movie_model.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getNowPlayingMovies(int page);
  Future<List<Movie>> getTopRatedMovies(int page);
}
