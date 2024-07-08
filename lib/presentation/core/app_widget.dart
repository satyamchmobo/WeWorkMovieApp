import 'package:flutter/material.dart';
import 'package:we_work/presentation/location/location_permission_page.dart';

class LocationPermission extends StatelessWidget {
  static const String routeName = "/locationPermissionPage";
  const LocationPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return const LocationPermissionPage();
  }
}
