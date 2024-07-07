import 'package:flutter/material.dart';
import 'dart:math' as math; // Import math with alias for clarity

/// A custom widget that animates a circular loading indicator resembling the WeWork logo.
class WeWorkLogoLoaderAnimation extends StatefulWidget {
  const WeWorkLogoLoaderAnimation({super.key});

  @override
  State<WeWorkLogoLoaderAnimation> createState() =>
      _WeWorkLogoLoaderAnimationState();
}

class _WeWorkLogoLoaderAnimationState extends State<WeWorkLogoLoaderAnimation>
    with SingleTickerProviderStateMixin {
  /// The animation controller that drives the rotation animation.
  late AnimationController _controller;

  /// The animation responsible for rotating the circular arc.
  late Animation<double> _rotationAnimation;

  /// Initializes the animation controller and rotation animation upon widget creation.
  @override
  void initState() {
    super.initState();

    // Creates an AnimationController that repeats indefinitely with a duration of 2 seconds.
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    // Creates a Tween animation that rotates the arc from 0 radians to 2 * pi radians (full circle).
    // Links the animation to the controller and listens for changes via the addListener method.
    _rotationAnimation = Tween(begin: 0.0, end: 2 * math.pi)
        .animate(_controller)
      ..addListener(() => setState(() {}));

    // Starts the animation controller, causing the rotation animation to repeat.
    _controller.repeat();
  }

  /// Disposes of the animation controller when the widget is no longer used.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Builds the widget tree, returning a CustomPaint widget that uses the _LoadingCirclularPainter.
  /// Passes the current rotation value from the animation to the painter.
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LoadingCirclularPainter(_rotationAnimation.value),
    );
  }
}

/// A custom painter that draws a circular arc with an animated rotation.
class _LoadingCirclularPainter extends CustomPainter {
  /// The current rotation value of the animation, used to define the arc's sweep angle.
  final double rotation;

  /// Creates a new _LoadingCirclularPainter instance with the provided rotation value.
  _LoadingCirclularPainter(this.rotation);

  /// Paints the circular arc onto the canvas based on the provided size and rotation.
  @override
  void paint(Canvas canvas, Size size) {
    // Creates a Paint object with properties for drawing the arc.
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Calculates the center and radius of the arc based on the widget's size.
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 80.0;

    // Draws an arc onto the canvas using the calculated center, radius, starting angle (0.0),
    // sweep angle (based on the rotation value), and paint object.
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0.0,
        rotation, false, paint);
  }

  /// Determines whether the painter should repaint itself based on changes in the rotation value.
  @override
  bool shouldRepaint(_LoadingCirclularPainter oldDelegate) =>
      oldDelegate.rotation != rotation;
}
