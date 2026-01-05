import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _rememberUserKey = 'remember_user';
  static const String _savedEmailKey = 'saved_email';

  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedEmailKey, email);
  }

  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedEmailKey);
  }

  static Future<void> setRememberUser(bool remember) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberUserKey, remember);
  }

  static Future<bool> isRememberUserEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberUserKey) ?? false;
  }

  static Future<void> clearSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedEmailKey);
    await prefs.remove(_rememberUserKey);
  }
}
