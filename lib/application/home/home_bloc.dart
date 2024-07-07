import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_work/domain/home/movie_model.dart';
import 'package:we_work/domain/home/movies_repository_service.dart';
import 'package:we_work/pagination_scroll_controller.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomePageBloc extends Bloc<HomeEvent, HomeState> {
  MoviesRepository? remoteDataSource;

  HomePageBloc({
    required this.remoteDataSource,
  }) : super(HomeInitial()) {
    on<HomeEventIntial>((event, emit) async {
      initializeValues();
    });
    on<NowPloyingLoadEvent>((event, emit) async {
      try {
        final List<Movie> result =
            await remoteDataSource!.getNowPlayingMovies(event.page);
        final list = event.prevMovies + result;
        emit(NowPlayingLoadSuccessState(list));
      } catch (e) {
        emit(NowPlayingLoadFailureState());
      }
    });

    on<TopRatedLoadEvent>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 200));
      try {
        final List<Movie> result =
            await remoteDataSource!.getTopRatedMovies(event.page);
        final list = event.prevMovies + result;

        emit(TopRatedLoadSuccessState(list));
      } catch (e) {
        emit(TopRatedLoadFailureState());
      }
    });
    on<RefreshPageEvent>((event, emit) async {
      emit(RefreshPageState());
    });

    on<MovieSearchEvent>((event, emit) async {
      try {
        final List<Movie> filteredNowPlayingMovies = event.nowPlayingMovies
            .where((movie) =>
                movie.title.toLowerCase().contains(event.keyWord.toLowerCase()))
            .toList();
        final List<Movie> filteredTopRatedMovies = event.topRatedMovies
            .where((movie) =>
                movie.title.toLowerCase().contains(event.keyWord.toLowerCase()))
            .toList();

        emit(FilterSuccessState(
            filteredNowPlayingMovies, filteredTopRatedMovies));
      } catch (e) {
        emit(FilterFailedState());
      }
    });
  }
  int nowPlayingPage = 1;
  int indexOfSelectedBottomNav = 0;
  int currentIndex = 0;
  int topRatedPage = 1;
  List<Movie> previousTopRatedMovies = [];
  List<Movie> allNowPlayingMovies = [];
  List<Movie> previousNowPlayingMovies = [];
  List<Movie> filteredNowPlayingMovies = [];
  List<Movie> allTopRatedMovies = [];
  List<Movie> filteredTopRatedMovies = [];
  initializeValues() {
    try {
      add(NowPloyingLoadEvent(nowPlayingPage, previousNowPlayingMovies));
      add(TopRatedLoadEvent(topRatedPage, previousTopRatedMovies));
      Connectivity().onConnectivityChanged.listen((result) {
        updateConnectivity(result != ConnectivityResult.none);
      });
    } catch (e) {}
  }

  clearAllList() {
    allNowPlayingMovies.clear();
    previousNowPlayingMovies.clear();
    allTopRatedMovies.clear();
    previousTopRatedMovies.clear();
  }

  resetPageNumbersAndIndex() {
    topRatedPage = 1;
    nowPlayingPage = 1;
    currentIndex = 0;
  }

  reAddBlocEvents() {
    add(NowPloyingLoadEvent(nowPlayingPage, previousNowPlayingMovies));
    add(TopRatedLoadEvent(topRatedPage, previousTopRatedMovies));
  }

  Future<void> onRefresh() async {
    // Simulate a long-running task
    await Future.delayed(const Duration(seconds: 2));
    add(RefreshPageEvent());
  }

  void updateConnectivity(dynamic hasConnection) async {
    debugPrint('hasCOnnected $hasConnection');
    if (hasConnection) {
      onRefresh();
    }
  }

  TextEditingController searchController = TextEditingController();
  late PaginationScrollController topRatedPaginationController;
  final ScrollController nowPlayingScrollController = ScrollController();
  final ScrollController nullScroll = ScrollController();
}
