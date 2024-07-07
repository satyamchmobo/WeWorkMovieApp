import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:we_work/presentation/home/widgets/trailing_list_titile.dart';

class MovieDetailsWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? votes;
  final double? rating;
  final bool? isFromTopRatedCard;
  final bool? hideVotes;
  final double? titleFontSize;
  final double? subTitleFontSize;

  final Color? fontColor;

  const MovieDetailsWidget({
    super.key,
    this.title,
    this.subTitle,
    this.titleFontSize,
    this.subTitleFontSize,
    this.votes,
    this.hideVotes = false,
    this.rating,
    this.fontColor,
    this.isFromTopRatedCard = false,
    required this.size,
  });

  final ui.Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width * 0.85,
            child: Text(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              '$title',
              style: TextStyle(
                  fontSize: titleFontSize ?? 14,
                  fontWeight: FontWeight.bold,
                  color: !isFromTopRatedCard!
                      ? fontColor ?? Colors.black
                      : Colors.black),
            ),
          ),
          SizedBox(
            height: hideVotes! ? 4 : 0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              !hideVotes!
                  ? Icon(
                      Icons.calendar_month_outlined,
                      size: 14,
                      color: fontColor ?? Colors.black,
                    )
                  : const SizedBox(),
              const SizedBox(
                width: 4,
              ),
              SizedBox(
                  width: size.width * 0.7,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    '$subTitle',
                    style: TextStyle(
                        fontSize: subTitleFontSize ?? 10,
                        color: fontColor ?? Colors.black),
                  )),
            ],
          ),
          SizedBox(
            height: isFromTopRatedCard! ? 10 : 1,
          ),
          Row(
            children: [
              !hideVotes!
                  ? Text(
                      '$votes Votes',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: fontColor ?? Colors.black),
                    )
                  : const SizedBox(),
              isFromTopRatedCard!
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9.0),
                      child: Text(
                        '|',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: fontColor ?? Colors.black),
                      ),
                    )
                  : const SizedBox(),
              isFromTopRatedCard!
                  ? TrailingListTitile(
                      text: double.parse(rating!.toStringAsFixed(1)).toString(),
                      fontSize: 16,
                      fontColor: fontColor ?? Colors.black,
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
