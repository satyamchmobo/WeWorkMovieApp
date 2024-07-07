import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_work/application/home/home_bloc.dart';
import 'package:we_work/core/config/enums.dart';
import 'package:we_work/core/services/auth_service.dart';
import 'package:we_work/core/services/auth_service_implementation.dart';
import 'package:we_work/domain/home/movies_repository_service.dart';
import 'package:we_work/infrastructure/home/movies_repository_service_impl.dart';

GetIt serviceLocator = GetIt.instance;
final sharedPreferencesService = serviceLocator<SharedPreferences>();
final authService = serviceLocator<AuthServiceImpl>();

Future<void> setupServiceLocator(Flavor flavor) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator
      .registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());
  serviceLocator.registerLazySingleton<AuthService>(() => AuthServiceImpl());

  serviceLocator.registerFactory(
    () => HomePageBloc(
      remoteDataSource: serviceLocator(),
    ),
  );
  serviceLocator
      .registerLazySingleton<MoviesRepository>(() => MoviesRepositoryImpl());
}
