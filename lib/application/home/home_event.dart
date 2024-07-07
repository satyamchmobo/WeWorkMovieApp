part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeEventIntial extends HomeEvent {
  const HomeEventIntial();
}

class NowPloyingLoadEvent extends HomeEvent {
  final int page;
  final List<Movie> prevMovies;

  const NowPloyingLoadEvent(this.page, this.prevMovies);
}

class TopRatedLoadEvent extends HomeEvent {
  final int page;
  final List<Movie> prevMovies;

  const TopRatedLoadEvent(this.page, this.prevMovies);
}

class RefreshPageEvent extends HomeEvent {}

class MovieSearchEvent extends HomeEvent {
  final String keyWord;
  final List<Movie> nowPlayingMovies;
  final List<Movie> topRatedMovies;

  const MovieSearchEvent(
      this.keyWord, this.nowPlayingMovies, this.topRatedMovies);
}
