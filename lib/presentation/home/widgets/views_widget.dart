import 'package:flutter/material.dart';
import 'package:we_work/core/helpers/helper_functions.dart';

class ViewsWidget extends StatelessWidget {
  final double? views;
  final Size size;

  const ViewsWidget(this.size, this.views, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.11,
      height: size.width * 0.11,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            applyTextScaling: false,
            Icons.remove_red_eye,
            color: Colors.white,
            size: size.width * 0.04,
          ),
          Text(
            formatValueToThousands(views),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
