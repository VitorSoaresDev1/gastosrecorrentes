import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferences? prefs;

  Future startSharedPreferences() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  Future<String?> getLanguageChoice() async {
    String? language = prefs!.getString('language');
    return language;
  }

  Future setlanguage(String? language) async {
    if (language == null) return;
    await prefs!.setString("language", language);
  }
}
