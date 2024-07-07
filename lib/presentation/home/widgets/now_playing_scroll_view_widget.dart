import 'package:flutter/material.dart';
import 'package:we_work/core/config/api_constants.dart';
import 'package:we_work/core/helpers/helper_functions.dart';
import 'package:we_work/domain/home/movie_model.dart';
import 'package:we_work/presentation/home/widgets/custom_plain_card.dart';
import 'package:we_work/presentation/home/widgets/now_playing_card.dart.dart';
import 'package:we_work/presentation/home/widgets/scroll_position_indicator.dart';

class NowPlayingScrollViewWidget extends StatelessWidget {
  const NowPlayingScrollViewWidget({
    super.key,
    required ScrollController scrollController,
    required List<Movie> allMovies,
    required int currentIndex,
  })  : _scrollController = scrollController,
        _allMovies = allMovies,
        _currentIndex = currentIndex;

  final ScrollController _scrollController;
  final List<Movie> _allMovies;
  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: MediaQuery.sizeOf(context).width -
                MediaQuery.sizeOf(context).width * 0.12,
            child: _allMovies.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _allMovies.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: NowPlayingCard(
                          rating: _allMovies[index].voteAverage,
                          imageUrl: _allMovies[index].posterPath != null
                              ? '${ApiConstants.baseUrlImage}${_allMovies[index].posterPath}'
                              : ApiConstants.imageUrlForNotFound,
                          size: Size(
                            MediaQuery.sizeOf(context).width -
                                MediaQuery.sizeOf(context).width * 0.3,
                            MediaQuery.sizeOf(context).width -
                                MediaQuery.sizeOf(context).width * 0.12,
                          ),
                          title: _allMovies[index].title,
                          subTitle: _allMovies[index].overview,
                          votes: _allMovies[index].voteCount.toDouble(),
                          views: _allMovies[index].popularity,
                          language:
                              getFullLanguageName(_allMovies[index].language),
                        ),
                      );
                    },
                  )
                : CustomPlainCard(
                    hideTopLeft: true,
                    title: 'No Data Found !',
                    size: Size(
                      MediaQuery.sizeOf(context).width -
                          MediaQuery.sizeOf(context).width * 0.3,
                      MediaQuery.sizeOf(context).width -
                          MediaQuery.sizeOf(context).width * 0.1,
                    ),
                    subTitle: '')),
        const SizedBox(
          height: 15,
        ),
        ScrollPositionIndicator(
            currentIndex: _currentIndex, length: _allMovies.length),
      ],
    );
  }
}
