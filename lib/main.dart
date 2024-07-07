import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we_work/application/application_life_cycle/application_life_cycle_cubit.dart';
import 'package:we_work/application/permission/permission_cubit.dart';
import 'package:we_work/core/config/enums.dart';
import 'package:we_work/injection.dart';
import 'package:we_work/presentation/core/app_widget.dart';
import 'package:we_work/presentation/home/pages/home_page.dart';
import 'core/services/service_locator.dart';
import 'presentation/splash/pages/wework_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //flavour passed as service locator have app config and api config singletons
  await setupServiceLocator(Flavor.dev);
  configureInjection(Environment.dev);
  runApp(const WeWorkMovieApp());
}

class WeWorkMovieApp extends StatelessWidget {
  const WeWorkMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PermissionCubit>(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => getIt<ApplicationLifeCycleCubit>(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        routes: {
          WeWorkSplashScreen.routeName: (context) => const WeWorkSplashScreen(),
          LocationPermission.routeName: (context) => const LocationPermission(),
          HomePage.routeName: (context) => const HomePage(),
        },
        title: 'We Work',
        debugShowCheckedModeBanner: false,
        home: const WeWorkSplashScreen(),
        // home: const SplashPage(),
      ),
    );
  }
}
