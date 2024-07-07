import 'package:flutter/material.dart';
import 'package:we_work/core/config/image_constants.dart';

/// [WeWorkLogo] represents the WeWork logo image displayed on the splash screen.
class WeWorkLogo extends StatelessWidget {
  const WeWorkLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      height: 165,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(ImageConstants.logo),
      ),
    );
  }
}
