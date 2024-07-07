import 'package:flutter/material.dart';

/// [BlackRing] represents a circular border that surrounds the WeWork logo on the splash screen.
class BlackRing extends StatelessWidget {
  const BlackRing({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      height: 165,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
    );
  }
}
