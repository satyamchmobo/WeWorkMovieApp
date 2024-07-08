import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_work/application/home/home_bloc.dart';
import 'package:we_work/application/location/location_cubit.dart';
import 'package:we_work/application/permission/permission_cubit.dart';
import 'package:we_work/core/services/service_locator.dart';
import 'package:we_work/domain/location_data_model.dart';
import 'package:we_work/presentation/home/pages/home_page.dart';
import '../../injection.dart';

class LocationPermissionPage extends StatefulWidget {
  const LocationPermissionPage({super.key});

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage>
    with SingleTickerProviderStateMixin {
  bool _isDone = false;
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  late bool isLocPermissionGranted;

  HomePageBloc homePageBloc = serviceLocator<HomePageBloc>();
  LocationDataModel? args;

  @override
  void initState() {
    final permissionCubit = context.read<PermissionCubit>();
    final isLocPermissionGranted =
        permissionCubit.state.isLocationPermissionGrantedAndServicesEnabled;
    if (!isLocPermissionGranted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            final bool isLocationPermissionGranted = context.select(
                (PermissionCubit element) =>
                    element.state.isLocationPermissionGranted);
            final bool isLocationServicesEnabled = context.select(
                (PermissionCubit element) =>
                    element.state.isLocationServicesEnabled);
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              content: PermissionDialog(
                isLocationPermissionGranted: isLocationPermissionGranted,
                isLocationServicesEnabled: isLocationServicesEnabled,
              ),
            );
          },
        );
      });
    }

    //initializing our home bloc
    homePageBloc.add(const HomeEventIntial());

    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.bounceIn,
    );
  }

  void _showDoneStatus() {
    setState(() {
      _isDone = true;
      _animationController?.forward();
    });
  }

  LocationDataModel? locationModel;

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  /// [navigateToHome] waits for a few seconds before navigating to the home page of the app.
  void navigateToHome(LocationDataModel locationDataModel) async {
    Navigator.pushNamedAndRemoveUntil(
        context, HomePage.routeName, (route) => false,
        arguments: locationDataModel);
  }

  @override
  void didChangeDependencies() {
    final permissionCubit = context.read<PermissionCubit>();
    isLocPermissionGranted =
        permissionCubit.state.isLocationPermissionGrantedAndServicesEnabled;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isLocPermissionGranted
        ? const HomePage()
        : BlocProvider(
            create: (context) => getIt<LocationCubit>(),
            child: MultiBlocListener(
              listeners: [
                BlocListener<PermissionCubit, PermissionState>(
                  listenWhen: (p, c) {
                    return p.isLocationPermissionGrantedAndServicesEnabled !=
                            c.isLocationPermissionGrantedAndServicesEnabled &&
                        c.isLocationPermissionGrantedAndServicesEnabled;
                  },
                  listener: (context, state) async {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                    _showDoneStatus();

                    if (context
                        .read<PermissionCubit>()
                        .state
                        .isLocationPermissionGrantedAndServicesEnabled) {
                      final result =
                          await context.read<LocationCubit>().getLocation();
                      locationModel = result;
                      navigateToHome(result);
                    }
                  },
                ),
                BlocListener<PermissionCubit, PermissionState>(
                  listenWhen: (p, c) =>
                      p.displayOpenAppSettingsDialog !=
                          c.displayOpenAppSettingsDialog &&
                      c.displayOpenAppSettingsDialog,
                  listener: (context, state) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          content: AppSettingsDialog(
                            openAppSettings: () {
                              debugPrint("Open App Settings pressed!");
                              context.read<PermissionCubit>().openAppSettings();
                            },
                            cancelDialog: () {
                              debugPrint("Cancel pressed!");
                              context
                                  .read<PermissionCubit>()
                                  .hideOpenAppSettingsDialog();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                BlocListener<PermissionCubit, PermissionState>(
                    listenWhen: (p, c) =>
                        p.displayOpenAppSettingsDialog !=
                            c.displayOpenAppSettingsDialog &&
                        !c.displayOpenAppSettingsDialog,
                    listener: (context, state) {
                      Navigator.of(context).pop();
                    }),
                BlocListener<LocationCubit, LocationState>(
                  listenWhen: (p, c) {
                    return p.userLocation != c.userLocation;
                  },
                  listener: (context, locationState) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      content: const Text(
                          'Location saved in cache ,ready to explore movies?'),
                      action: SnackBarAction(
                          label: 'Sure',
                          onPressed: () {
                            if (locationModel != null) {
                              navigateToHome(locationModel!);
                            }
                          }),
                    ));
                  },
                ),
              ],
              child: Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10),
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                        Flexible(
                            child: Text(
                          maxLines: 1,
                          'WeWork requires location permission !',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: [
                          ScaleTransition(
                            scale: _scaleAnimation!,
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey,
                              size: 100,
                            ),
                          ),
                          const SizedBox(height: 20),
                          AnimatedOpacity(
                            opacity: _isDone ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: const Text(
                              'Thanks for location !',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        BlocSelector<PermissionCubit, PermissionState, bool>(
                          selector: (state) {
                            return state
                                .isLocationPermissionGrantedAndServicesEnabled;
                          },
                          builder: (context,
                              isLocationPermissionGrantedAndServicesEnabled) {
                            return isLocationPermissionGrantedAndServicesEnabled
                                ? const SizedBox.shrink()
                                : const Positioned(
                                    right: 30,
                                    bottom: 50,
                                    child: LocationButton(),
                                  );
                          },
                        ),
                        BlocBuilder<LocationCubit, LocationState>(
                          buildWhen: (p, c) {
                            return p.isUserLocationReady !=
                                c.isUserLocationReady;
                          },
                          builder: (context, state) {
                            return !state.isUserLocationReady
                                ? const SizedBox.shrink()
                                : Positioned(
                                    left: 30,
                                    bottom: 50,
                                    child: CenterButton(
                                      onPressed: () {
                                        // mapController.move(
                                        //   LatLng(state.userLocation.latitude,
                                        //       state.userLocation.longitude),
                                        //   mapController.zoom,
                                        // );
                                      },
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class UserMarker extends StatefulWidget {
  const UserMarker({super.key});

  @override
  State<UserMarker> createState() => _UserMarkerState();
}

class _UserMarkerState extends State<UserMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    sizeAnimation = Tween<double>(
      begin: 45,
      end: 60,
    ).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.repeat(
      reverse: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sizeAnimation,
      builder: (context, child) {
        return Center(
          child: Container(
            width: sizeAnimation.value,
            height: sizeAnimation.value,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: child,
          ),
        );
      },
      child: const Icon(
        Icons.person_pin,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}

class CenterButton extends StatelessWidget {
  final Function onPressed;
  const CenterButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            return Colors.black;
          },
        ),
      ),
      onPressed: () {
        debugPrint("Center button Pressed!");

        onPressed();
      },
      child: const Text("Center"),
    );
  }
}

class LocationButton extends StatelessWidget {
  const LocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            return Colors.black;
          },
        ),
      ),
      onPressed: () {
        debugPrint("Location Services button Pressed!");

        showDialog(
          context: context,
          builder: (BuildContext context) {
            final bool isLocationPermissionGranted = context.select(
                (PermissionCubit element) =>
                    element.state.isLocationPermissionGranted);
            final bool isLocationServicesEnabled = context.select(
                (PermissionCubit element) =>
                    element.state.isLocationServicesEnabled);
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              content: PermissionDialog(
                isLocationPermissionGranted: isLocationPermissionGranted,
                isLocationServicesEnabled: isLocationServicesEnabled,
              ),
            );
          },
        );
      },
      child: const Text("Request Location Permission"),
    );
  }
}

class PermissionDialog extends StatelessWidget {
  final bool isLocationPermissionGranted;
  final bool isLocationServicesEnabled;
  const PermissionDialog({
    super.key,
    required this.isLocationPermissionGranted,
    required this.isLocationServicesEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text(
            "Please allow location permission and services to view your location:)"),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Location Permission: "),
            TextButton(
              onPressed: isLocationPermissionGranted
                  ? null
                  : () {
                      debugPrint("Location permission button pressed!");
                      context
                          .read<PermissionCubit>()
                          .requestLocationPermission();
                    },
              child: Text(isLocationPermissionGranted ? "allowed" : "allow"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Location Services: "),
            TextButton(
              onPressed: isLocationServicesEnabled
                  ? null
                  : () {
                      debugPrint("Location services button pressed!");
                      context.read<PermissionCubit>().openLocationSettings();
                    },
              child: Text(isLocationServicesEnabled ? "allowed" : "allow"),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class AppSettingsDialog extends StatelessWidget {
  final Function openAppSettings;
  final Function cancelDialog;
  const AppSettingsDialog({
    super.key,
    required this.openAppSettings,
    required this.cancelDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text(
            "You need to open app settings to grant Location Permission"),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                openAppSettings();
              },
              child: const Text("Open App Settings"),
            ),
            TextButton(
              onPressed: () {
                cancelDialog();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
