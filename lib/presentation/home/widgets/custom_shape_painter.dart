import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:we_work/presentation/home/widgets/create_custom_shape_path.dart';

class CustomShapePainter extends CustomPainter {
  final ui.Image? image;
  bool? darkGradient;
  bool? hideTopLeftWidget;
  bool? hideTopRightWidget;
  bool? moveTopRightWidgetToCenter;

  CustomShapePainter(
    this.image, {
    this.darkGradient = false,
    this.hideTopLeftWidget = false,
    this.hideTopRightWidget = false,
    this.moveTopRightWidgetToCenter = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path = createCustomShapePath(size);
    // Clip the canvas to the custom shape
    canvas.clipPath(path);

    if (image == null) {
      Paint gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topLeft,
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.15),
          ],
        ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
      canvas.drawPath(path, gradientPaint);
    }

    if (image == null && darkGradient!) {
      Paint gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.5),
          ],
        ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
      canvas.drawPath(path, gradientPaint);
    }

    // Draw the image within the clipped area
    if (image != null) {
      canvas.drawImageRect(
        image!,
        Rect.fromLTRB(
            0, 0, image!.width.toDouble(), image!.height.toDouble() - 200),
        Rect.fromLTRB(0, 0, size.width, size.height),
        Paint(),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
