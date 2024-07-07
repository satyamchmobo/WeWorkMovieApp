import 'package:flutter/cupertino.dart';
import 'package:we_work/presentation/home/widgets/create_custom_shape_path.dart';

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return createCustomShapePath(size);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
