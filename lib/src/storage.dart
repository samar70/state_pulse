import 'package:shared_preferences/shared_preferences.dart';

class StatePulseStorage {
  static late SharedPreferences _prefs;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  static String? read(String key) {
    if (!_initialized) return null;
    return _prefs.getString(key);
  }

  static Future<void> write(String key, String value) async {
    if (!_initialized) return;
    await _prefs.setString(key, value);
  }

  static Future<void> remove(String key) async {
    if (!_initialized) return;
    await _prefs.remove(key);
  }
}
