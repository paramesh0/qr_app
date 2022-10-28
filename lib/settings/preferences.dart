

import 'package:shared_preferences/shared_preferences.dart';


class Preferences {
  static SharedPreferences? preferences;
  static const String loginStatus = 'loginStatus';

  static init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static setLoginStatus(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(loginStatus, value);
    }
  }

  static Future<String> getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userUUid = prefs.getString(loginStatus);
    return userUUid ?? '';
  }


}
