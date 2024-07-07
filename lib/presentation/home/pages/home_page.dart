import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_work/application/home/home_bloc.dart';
import 'package:we_work/bottom_nav_bar.dart';
import 'package:we_work/core/config/shared_preference_constants.dart';
import 'package:we_work/domain/location_data_model.dart';
import 'package:we_work/core/services/service_locator.dart';
import 'package:we_work/pagination_scroll_controller.dart';
import 'package:we_work/presentation/home/pages/search_field.dart';
import 'package:we_work/presentation/home/widgets/custom_plain_card.dart';
import 'package:we_work/presentation/home/widgets/custom_text_seperator.dart';
import 'package:we_work/presentation/home/widgets/location_details_widget.dart';
import 'package:we_work/presentation/home/widgets/now_playing_scroll_view_widget.dart';
import 'package:we_work/presentation/home/widgets/top_rated_scroll_view_widget.dart';
import 'package:we_work/ui_kit.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });
  static const String routeName = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageBloc homePageBloc = serviceLocator<HomePageBloc>();
  LocationDataModel? args;
  @override
  void initState() {
    super.initState();
    //initializing our home bloc
    homePageBloc.add(const HomeEventIntial());
    //setting up listeners for horizontal and vertical controllers
    //so that we can trigger pagination
    initializeScrollControllers();
  }

  @override
  void dispose() {
    homePageBloc.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    args = ModalRoute.of(context)!.settings.arguments as LocationDataModel?;
    if (args == null) {
      String? mainAddress = '';
      String? secondaryAddress = '';
      if (sharedPreferencesService
              .containsKey(SharedPrefrenceConstants.mainAddress) &&
          sharedPreferencesService
              .containsKey(SharedPrefrenceConstants.secondaryAddress)) {
        mainAddress = sharedPreferencesService
            .getString(SharedPrefrenceConstants.mainAddress);
        secondaryAddress = sharedPreferencesService
            .getString(SharedPrefrenceConstants.secondaryAddress);
      }

      args = LocationDataModel(
          mainAddress: mainAddress, secondaryAddress: secondaryAddress);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(
        onBottomItemTapped: onBottomItemTapped,
      ),
      floatingActionButton: fab(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: primaryBgDecoration,
        child: SafeArea(
          child: Center(
            child: BlocBuilder<HomePageBloc, HomeState>(
                bloc: homePageBloc,
                builder: (context, state) {
                  if (state is RefreshPageState) {
                    processVariablesForRefresh();
                  }
                  if (state is NowPlayingLoadSuccessState) {
                    changeNowPlayingLoadSuccessState(state);
                  }

                  if (state is TopRatedLoadSuccessState) {
                    changeTopRatedLoadSuccessState(state);
                  }
                  if (state is FilterSuccessState) {
                    changeFilterSuccessState(state);
                  }
                  if (state is NowPlayingLoadErrorState) {}
                  return RefreshIndicator(
                    edgeOffset: 100,
                    onRefresh: homePageBloc.onRefresh,
                    child: scrollBody(args),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget scrollBody(LocationDataModel? args) {
    return CustomScrollView(
      controller: homePageBloc.searchController.text.isEmpty
          ? homePageBloc.topRatedPaginationController.scrollController
          : homePageBloc.nullScroll,
      slivers: [
        sliverAppBar(args),
        sliverPersistentHeader(),
        sliverFillRemaining(),
        TopRatedScrollViewWidget(
          allMovies: homePageBloc.filteredTopRatedMovies,
        ),
      ],
    );
  }

  SliverAppBar sliverAppBar(LocationDataModel? args) {
    return SliverAppBar(
      elevation: 0,
      forceMaterialTransparency: true,
      flexibleSpace: SafeArea(
        maintainBottomViewPadding: true,
        child: LocationDetailsWidget(
          mainAddress: args?.mainAddress ?? "mainAd",
          secondaryAddress: args?.secondaryAddress ?? 'secondAdd',
        ),
      ),
    );
  }

  SliverPersistentHeader sliverPersistentHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SearchField(
        controller: homePageBloc.searchController,
        onTextChanged: (value) {
          searchMovies(value);
        },
      ),
    );
  }

  SliverFillRemaining sliverFillRemaining() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(children: [
              // searchField(),k
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CustomPlainCard(
                  size: Size(MediaQuery.sizeOf(context).width, 110),
                  title: 'We Movies',
                  subTitle:
                      '${homePageBloc.allNowPlayingMovies.length} Movies are loaded in now playing',
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                child: CustomTextSeperator(
                  title: 'NOW PLAYING',
                ),
              )
            ]),
          ),
          NowPlayingScrollViewWidget(
              scrollController: homePageBloc.searchController.text.isEmpty
                  ? homePageBloc.nowPlayingScrollController
                  : homePageBloc.nullScroll,
              allMovies: homePageBloc.filteredNowPlayingMovies,
              currentIndex: homePageBloc.currentIndex),
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: CustomTextSeperator(
              title: 'TOP RATED',
            ),
          )
        ],
      ),
    );
  }

  changeFilterSuccessState(FilterSuccessState state) {
    homePageBloc.filteredNowPlayingMovies = state.filteredNowPlayingMovies;
    homePageBloc.filteredTopRatedMovies = state.filteredTopRatedMovies;
  }

  changeTopRatedLoadSuccessState(TopRatedLoadSuccessState state) {
    homePageBloc.allTopRatedMovies = state.topRatedMoviesList;
    homePageBloc.previousTopRatedMovies = homePageBloc.allTopRatedMovies;
    homePageBloc.filteredTopRatedMovies = state.topRatedMoviesList;
    homePageBloc.topRatedPage++;
  }

  changeNowPlayingLoadSuccessState(NowPlayingLoadSuccessState state) {
    homePageBloc.allNowPlayingMovies = state.nowPlayingMoviesList;
    homePageBloc.previousNowPlayingMovies = homePageBloc.allNowPlayingMovies;
    homePageBloc.filteredNowPlayingMovies = state.nowPlayingMoviesList;
    homePageBloc.nowPlayingPage++;
  }

  void processVariablesForRefresh() {
    homePageBloc.clearAllList();
    homePageBloc.resetPageNumbersAndIndex();
    reInitialilzeScrollControllers();
    homePageBloc.reAddBlocEvents();
  }

  initializeScrollControllers() {
    homePageBloc.topRatedPaginationController = PaginationScrollController();
    homePageBloc.topRatedPaginationController.init(
      initAction: () {
        homePageBloc.add(TopRatedLoadEvent(
            homePageBloc.topRatedPage, homePageBloc.previousTopRatedMovies));
      },
      loadAction: () async {
        homePageBloc.add(TopRatedLoadEvent(
            homePageBloc.topRatedPage, homePageBloc.previousTopRatedMovies));
        return false; // Return true to stop loading more
      },
    );
    homePageBloc.nowPlayingScrollController.addListener(_onNowPlayingScroll);
  }

  reInitialilzeScrollControllers() {
    homePageBloc.topRatedPaginationController.init(
      initAction: () {
        homePageBloc.add(TopRatedLoadEvent(
            homePageBloc.topRatedPage, homePageBloc.previousTopRatedMovies));
      },
      loadAction: () async {
        // Simulate a network call or data fetching
        await Future.delayed(const Duration(seconds: 1));
        homePageBloc.add(TopRatedLoadEvent(
            homePageBloc.topRatedPage, homePageBloc.previousTopRatedMovies));
        return false; // Return true to stop loading more
      },
    );
    homePageBloc.nowPlayingScrollController.addListener(_onNowPlayingScroll);
  }

  void onBottomItemTapped(int index) {
    setState(() {
      homePageBloc.indexOfSelectedBottomNav = index;
    });
  }

  void searchMovies(String searchText) {
    homePageBloc.add(MovieSearchEvent(searchText,
        homePageBloc.allNowPlayingMovies, homePageBloc.allTopRatedMovies));
  }

  void _onNowPlayingScroll() {
    if (isNowPlayingBottom) {
      homePageBloc.add(NowPloyingLoadEvent(
          homePageBloc.nowPlayingPage, homePageBloc.previousNowPlayingMovies));
    }
    // Update current index based on scroll position
    final double cardWidth = MediaQuery.sizeOf(context).width *
        0.3; // Assuming fixed width of each card
    final double scrollOffset = homePageBloc.nowPlayingScrollController.offset;
    final double screenWidth = MediaQuery.of(context).size.width;
    final int newIndex = (scrollOffset / (screenWidth + cardWidth)).ceil();
    if (newIndex != homePageBloc.currentIndex) {
      setState(() {
        homePageBloc.currentIndex = newIndex;
      });
    }
  }

  bool get isNowPlayingBottom {
    if (!homePageBloc.nowPlayingScrollController.hasClients) return false;
    final maxScroll =
        homePageBloc.nowPlayingScrollController.position.maxScrollExtent - 200;
    final currentScroll =
        homePageBloc.nowPlayingScrollController.position.pixels;
    return currentScroll >= maxScroll;
  }

  FloatingActionButton fab() {
    return FloatingActionButton(
      onPressed: () {
        homePageBloc.topRatedPaginationController.scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: const Icon(Icons.arrow_upward),
    );
  }
}
