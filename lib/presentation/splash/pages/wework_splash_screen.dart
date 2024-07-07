import 'package:flutter/material.dart';

import 'package:we_work/presentation/core/app_widget.dart';
import 'package:we_work/presentation/splash/widgets/black_ring.dart';
import 'package:we_work/presentation/splash/widgets/positioned_logo_animation.dart';
import 'package:we_work/presentation/splash/widgets/we_work_logo.dart';

/// [WeWorkSplashScreen] represents the splash screen of the WeWork app, displaying an animated logo
/// and navigating to the home page after a delay.
class WeWorkSplashScreen extends StatefulWidget {
  static const String routeName = "/splash";

  const WeWorkSplashScreen({super.key});

  @override
  _WeWorkSplashScreenState createState() => _WeWorkSplashScreenState();
}

/// [_WeWorkSplashScreenState] handles the state management and navigation logic for [WeWorkSplashScreen].
class _WeWorkSplashScreenState extends State<WeWorkSplashScreen> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      navigateToHome();
      // navigateToLocationPermissionScreen();
    }
  }

  /// [navigateToHome] waits for a few seconds before navigating to the home page of the app.
  void navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5)).then((value) {
      Navigator.pushNamedAndRemoveUntil(
          context, LocationPermission.routeName, (route) => false,
          arguments: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  /// [body] builds the UI of the splash screen, containing the logo and its animations.
  Widget body(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Stack(
          children: [
            // Circular loader animation
            PositionedLogoAnimation(),
            // The actual WeWork logo image
            WeWorkLogo(),
            // The border outside the logo over which the fill-up loader will be shown
            BlackRing()
          ],
        ),
      ),
    );
  }
}
