import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('username') && prefs.containsKey('role');
  }
}
