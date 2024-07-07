import 'package:flutter/material.dart';
import 'package:we_work/presentation/splash/widgets/we_work_logo_loader_animation.dart';

/// [PositionedLogoAnimation] represents the animation widget for the WeWork logo on the splash screen.
class PositionedLogoAnimation extends StatelessWidget {
  const PositionedLogoAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: WeWorkLogoLoaderAnimation(),
    );
  }
}
