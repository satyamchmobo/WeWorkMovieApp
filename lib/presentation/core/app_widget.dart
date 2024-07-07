import 'package:flutter/material.dart';
import '../map/map_page.dart';

class LocationPermission extends StatelessWidget {
  static const String routeName = "/locationPermissionPage";
  const LocationPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return const LocationPermissionPage();
  }
}
