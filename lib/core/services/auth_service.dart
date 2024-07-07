abstract class AuthService {
  Future<void> deleteToken();
  Future<String?> fetchToken();
}
