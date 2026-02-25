import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences sharedPreferences;
  const SharedPreferencesService({required this.sharedPreferences});

  Future<void> setBool(String key, bool value) async {
    await sharedPreferences.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    
    return sharedPreferences.getBool(key) ?? false;
  }

  Future<void> setString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return sharedPreferences.getString(key);
  }

  Future<String?> getStringForTheme(String key) async {
    return sharedPreferences.getString(key);
  }

  Future<void> remove(String key) async {
    await sharedPreferences.remove(key);
  }
}
