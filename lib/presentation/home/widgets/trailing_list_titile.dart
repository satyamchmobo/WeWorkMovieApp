import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:we_work/core/config/image_constants.dart';

class TrailingListTitile extends StatelessWidget {
  final double? fontSize;
  final String? text;
  final Color? fontColor;
  final bool? hideStar;
  const TrailingListTitile({
    super.key,
    this.fontSize = 18,
    this.text,
    this.fontColor = Colors.black,
    this.hideStar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$text ',
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: ui.FontWeight.bold,
              color: fontColor),
        ),
        !hideStar!
            ? const Image(
                image: AssetImage(ImageConstants.star),
                height: 20,
                width: 20,

              )
            : const SizedBox(),
      ],
    );
  }
}
