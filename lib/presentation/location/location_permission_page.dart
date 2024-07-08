import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_work/application/home/home_bloc.dart';
import 'package:we_work/application/location/location_cubit.dart';
import 'package:we_work/application/permission/permission_cubit.dart';
import 'package:we_work/core/services/service_locator.dart';
import 'package:we_work/domain/location_data_model.dart';
import 'package:we_work/presentation/home/pages/home_page.dart';
import 'package:we_work/presentation/location/widgets/app_settings_dialog.dart';
import 'package:we_work/presentation/location/widgets/permission_dialog.dart';
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
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
                    const SizedBox(
                      height: 130,
                    ),
                    SizedBox(
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
                  ],
                ),
              ),
            ),
          );
  }
}
