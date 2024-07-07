import 'package:we_work/core/config/shared_preference_constants.dart';
import 'package:we_work/core/services/auth_service.dart';
import 'package:we_work/core/services/service_locator.dart';

class AuthServiceImpl implements AuthService {
  String? authToken;

  @override
  Future<void> deleteToken() async {
    await sharedPreferencesService.remove(SharedPrefrenceConstants.token);
  }

  @override
  Future<String?> fetchToken() async {
    if (authToken != null) {
      return authToken;
    } else {
      authToken =
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YTg3ZTY4MDMyODIwMTIzZmQ0Yzg0YjQzNDhjYjc3ZCIsInN1YiI6IjY2Mjg5NDExOTFmMGVhMDE0YjAwOWU1ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6zIM73Giwg5M4wP6MX8KDCpee7IMnpnLTZUyMpETb08';
      sharedPreferencesService.setString(
          SharedPrefrenceConstants.token, authToken!);
      return authToken;
    }
  }
}
