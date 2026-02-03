import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static final AppPreferences _instance = AppPreferences._internal();
  late SharedPreferences _prefs;

  AppPreferences._internal();

  static AppPreferences get instance => _instance;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isDarkTheme => _prefs.getBool('isDarkTheme') ?? false;

  Future<void> setDarkTheme(bool value) => _prefs.setBool('isDarkTheme', value);

  bool get hasSeenOnboarding =>
      _prefs.getBool('hasSeenOnboarding') ?? false;

  Future<void> setSeenOnboarding() =>
      _prefs.setBool('hasSeenOnboarding', true);
}
