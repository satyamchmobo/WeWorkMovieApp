import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we_work/presentation/home/widgets/movie_details_widget.dart';
import 'package:we_work/presentation/home/widgets/views_widget.dart';

class TopRatedMovieCard extends StatelessWidget {
  final String imageUrl;
  final Size size;

  final String title;
  final String subTitle;
  final String votes;
  final double rating;
  final double? views;

  final double borderRadius;

  const TopRatedMovieCard({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.title,
    required this.subTitle,
    required this.votes,
    required this.rating,
    required this.views,
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          children: [
            Stack(children: [
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: SizedBox(
                      width: double.infinity,
                      height: size.height * 0.6,
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) => const Center(
                            child: CircularProgressIndicator(
                          color: Colors.black38,
                        )),
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.4, left: 10),
                  child: ViewsWidget(size, views),
                ),
              ),
            ]),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0, left: 5),
                child: MovieDetailsWidget(
                  fontColor: Colors.black54,
                  size: size,
                  title: title,
                  subTitle: subTitle,
                  subTitleFontSize: 12,
                  titleFontSize: 16,
                  hideVotes: false,
                  isFromTopRatedCard: true,
                  votes: votes,
                  rating: rating,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
