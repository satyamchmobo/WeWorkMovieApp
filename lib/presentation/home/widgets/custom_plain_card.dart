import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:we_work/core/helpers/helper_functions.dart';
import 'package:we_work/presentation/home/widgets/custom_shape_clipper.dart';
import 'package:we_work/presentation/home/widgets/custom_shape_painter.dart';
import 'package:we_work/presentation/home/widgets/movie_details_widget.dart';
import 'package:we_work/presentation/home/widgets/trailing_list_titile.dart';

class CustomPlainCard extends StatelessWidget {
  final String? imageUrl;
  final bool? hideTopLeft;

  final String? title;
  final String? subTitle;

  final Size size;

  const CustomPlainCard({
    super.key,
    this.imageUrl,
    this.hideTopLeft = false,
    required this.title,
    required this.size,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(children: [
        Align(
          alignment: AlignmentDirectional.topCenter,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: CustomPaint(
                painter: CustomShapePainter(null),
                size: size,
              ),
            ),
          ),
        ),
        !hideTopLeft!
            ? Align(
                alignment: AlignmentDirectional.topCenter,
                child: Row(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Expanded(
                      flex: 2,
                      child: TrailingListTitile(
                        text: getFormattedDate(),
                        hideStar: true,
                        fontSize: 13,
                      ),
                    ),
                    const Expanded(
                      flex: 3,
                      child: SizedBox(),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        Align(
          alignment: AlignmentDirectional.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 5),
            child: MovieDetailsWidget(
              size: size * 0.7,
              title: title,
              subTitle: subTitle,
              hideVotes: true,
            ),
          ),
        ),
      ]),
    );
  }
}
