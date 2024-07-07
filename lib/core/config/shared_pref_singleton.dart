import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_work/core/config/shared_preference_constants.dart';

class PrefsManager {
  // Private constructor
  PrefsManager._privateConstructor();

  // The single instance of the class
  static PrefsManager? _instance;

  // Public getter to access the instance
  static PrefsManager getInstance() {
    _instance ??= PrefsManager._privateConstructor();
    return _instance!;
  }

  static SharedPreferences? _prefs;

  // Initialize the shared preferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Methods to interact with shared preferences
  Future<void> setToken(String token) async {
    await _prefs?.setString(SharedPrefrenceConstants.token, token);
  }

  String? fetchToken() {
    return _prefs?.getString(SharedPrefrenceConstants.token);
  }

  Future<void> deleteToken() async {
    await _prefs?.remove(SharedPrefrenceConstants.token);
  }

  // Methods for main and secondary addresses
  Future<void> setmainAddress(String address) async {
    await _prefs?.setString(SharedPrefrenceConstants.mainAddress, address);
  }

  String? getmainAddress() {
    return _prefs?.getString(SharedPrefrenceConstants.mainAddress);
  }

  Future<void> setSecondaryAddress(String address) async {
    await _prefs?.setString(SharedPrefrenceConstants.secondaryAddress, address);
  }

  String? getSecondaryAddress() {
    return _prefs?.getString(SharedPrefrenceConstants.secondaryAddress);
  }
}
