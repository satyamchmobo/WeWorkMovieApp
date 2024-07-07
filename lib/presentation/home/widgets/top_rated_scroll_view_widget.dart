import 'package:flutter/material.dart';
import 'package:we_work/core/config/api_constants.dart';
import 'package:we_work/domain/home/movie_model.dart';
import 'package:we_work/presentation/home/widgets/top_rated_card.dart';

class TopRatedScrollViewWidget extends StatelessWidget {
  const TopRatedScrollViewWidget({
    super.key,
    required List<Movie> allMovies,
  }) : _allMovies = allMovies;

  final List<Movie> _allMovies;
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 2),
            child: _allMovies.isNotEmpty
                ? SizedBox(
                    child: TopRatedMovieCard(
                    imageUrl: _allMovies[index].posterPath != null
                        ? '${ApiConstants.baseUrlImage}${_allMovies[index].posterPath}'
                        : ApiConstants.imageUrlForNotFound,
                    size: Size(MediaQuery.sizeOf(context).width,
                        MediaQuery.sizeOf(context).width * 0.8),
                    title: _allMovies[index].title,
                    subTitle: _allMovies[index].overview,
                    votes: _allMovies[index].voteCount.toString(),
                    rating: _allMovies[index].voteAverage,
                    views: _allMovies[index].popularity,
                  ))
                : const SizedBox(
                    height: 100,
                    child: Text('No data found !'),
                  ),
          ));
        },
        childCount: _allMovies.isNotEmpty ? _allMovies.length : 1,
      ),
    );
  }
}
