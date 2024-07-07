part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class NowPlayingLoadSuccessState extends HomeState {
  final List<Movie> nowPlayingMoviesList;
  const NowPlayingLoadSuccessState(this.nowPlayingMoviesList);
  @override
  List<Object> get props => [nowPlayingMoviesList];
}

class NowPlayingLoadFailureState extends HomeState {}

class NowPlayingLoadProgressState extends HomeState {}

class NowPlayingLoadErrorState extends HomeState {}

class TopRatedLoadSuccessState extends HomeState {
  final List<Movie> topRatedMoviesList;
  const TopRatedLoadSuccessState(this.topRatedMoviesList);
  @override
  List<Object> get props => [topRatedMoviesList];
}

class TopRatedLoadFailureState extends HomeState {}

class TopRatedLoadProgressState extends HomeState {}

class TopRatedLoadErrorState extends HomeState {}

class RefreshPageState extends HomeState {}

class FilterSuccessState extends HomeState {
  final List<Movie> filteredNowPlayingMovies;
  final List<Movie> filteredTopRatedMovies;

  const FilterSuccessState(
      this.filteredNowPlayingMovies, this.filteredTopRatedMovies);
  @override
  List<Object> get props => [filteredNowPlayingMovies, filteredTopRatedMovies];
}

class FilterFailedState extends HomeState {}
