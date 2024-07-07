import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we_work/core/helpers/helper_functions.dart';
import 'package:we_work/presentation/home/widgets/custom_shape_painter.dart';
import 'package:we_work/presentation/home/widgets/extended_custom_list_title.dart';
import 'package:we_work/presentation/home/widgets/movie_details_widget.dart';
import 'package:we_work/presentation/home/widgets/trailing_list_titile.dart';

import 'custom_shape_clipper.dart';

class NowPlayingCard extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? subTitle;
  final String? language;
  final double? rating;
  final double? views;
  final double? votes;

  final Size size;

  const NowPlayingCard({
    super.key,
    this.imageUrl,
    required this.rating,
    required this.language,
    required this.votes,
    required this.views,
    required this.title,
    required this.size,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: loadImage(CachedNetworkImageProvider(imageUrl!)),
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        return SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: SizedBox(
                    height: snapshot.hasData
                        ? size.height - size.height * 0.1
                        : size.height,
                    width: size.width,
                    child: SizedBox(
                      height: size.height,
                      width: size.width,
                      child: CustomPaint(
                        painter: CustomShapePainter(snapshot.data),
                        size: Size(size.width, size.height),
                        child: !snapshot.hasData
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.black38,
                              ))
                            : Stack(children: [
                                Align(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        height: 35,
                                        width: 30,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: TrailingListTitile(
                                          text: double.parse(
                                                  rating!.toStringAsFixed(1))
                                              .toString(),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: ExtendedCustomListTitle(
                                          text: formatValueToRoundedThousands(
                                              votes),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                      ),
                    )),
              ),
              snapshot.hasData
                  ? Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: SizedBox(
                        height: size.height * 0.38,
                        width: size.width,
                        child: Stack(children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: ClipPath(
                              clipper: CustomShapeClipper(),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 15.0, sigmaY: 15.0),
                                child: CustomPaint(
                                  painter: CustomShapePainter(null,
                                      darkGradient: true),
                                  size: size,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Row(
                              children: [
                                const Expanded(flex: 2, child: SizedBox()),
                                Expanded(
                                  flex: 3,
                                  child: ExtendedCustomListTitle(
                                    moveTopRightWidgetToLeft: true,
                                    icon: Icons.language,
                                    text: language,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 40.0, left: 5),
                              child: MovieDetailsWidget(
                                title: title,
                                size: size,
                                fontColor: Colors.white,
                                subTitle: subTitle,
                                votes: formatValueToThousands(views),
                              ),
                            ),
                          ),
                        ]),
                      ))
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}

// Function to convert ImageProvider to ui.Image
Future<ui.Image> loadImage(ImageProvider provider) async {
  Completer<ui.Image> completer = Completer();
  final ImageStream stream = provider.resolve(ImageConfiguration.empty);
  final listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
    completer.complete(info.image);
  });

  stream.addListener(listener);
  return completer.future;
}
