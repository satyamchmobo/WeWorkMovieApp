import 'package:flutter/material.dart';
import 'package:we_work/presentation/location/location_permission_page.dart';

// made so that we can add BlocSelector or BlocListner here to perform inital actions or decide on navigaton as per persmnisson statuses
class LocationPermission extends StatelessWidget {
  static const String routeName = "/locationPermissionPage";
  const LocationPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return const LocationPermissionPage();
  }
}
