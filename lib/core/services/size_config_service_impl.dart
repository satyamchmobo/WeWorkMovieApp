// import 'package:flutter/material.dart';
// import 'package:we_work/core/services/size_config_service.dart';
//
// /// This is a Flutter class that implements a custom interface called [SizeConfig]. The purpose of the [SizeConfig] interface is to provide a set of methods for handling size-related calculations and transformations in a Flutter app.
// ///
// /// The [AppSizeConfigImpl] class has three properties: [screenWidth], [screenHeight], and [dp]. These properties are initialized to zero, but their values are set later when the [init] method is called. The [init] method takes a [BuildContext] as its argument and uses it to retrieve the device screen size using [MediaQuery.of(context)]. The [screenWidth] and [screenHeight] properties are then set based on the screen size. [dp] is also initialized based on the screen width, with the assumption that the device has a screen density of 160 pixels per inch.
// ///
// /// The [getPropHeight] and [getPropWidth] methods are used to convert static sizes (specified in the code) to proportional sizes that are appropriate for the current screen size. The static size values are provided as arguments to these methods, and the methods return proportional sizes that are calculated based on the current screen size. The [getPropHeight] method calculates a proportional height value based on the [staticHeight] argument and the screen height, while the [getPropWidth] method calculates a proportional width value based on the [staticWidth] argument and the screen width.
// class AppSizeConfigImpl implements SizeConfig {
//   double screenWidth = 0.0;
//   double screenHeight = 0.0;
//   double dp = 0.0;
//   late Styling style;
//
//   @override
//   void init(BuildContext context) {
//     if (config.showLogs) apiService.log.d("AppSizeConfigImpl.init()");
//     final mediaQuery = MediaQuery.of(context);
//     screenWidth = mediaQuery.size.width;
//     screenHeight = mediaQuery.size.height;
//     dp = screenWidth / 160;
//     style = Styling.instance;
//     style.init();
//   }
//
//   double getPropHeight(double staticHeight) {
//     return screenHeight * (staticHeight / 896);
//   }
//
//   double getPropWidth(double staticWidth) {
//     return screenWidth * (staticWidth / 414);
//   }
// }
