import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'scrap.dart';

class Util {
  static Future<List<ScrapboxProjectPref>> getPrefProjects() async {
    final pref = await SharedPreferences.getInstance();
    final result = pref.getString("projects") ?? "[]";

    final j = json.decode(result) as List<dynamic>;

    return j.map((e) => ScrapboxProjectPref.fromJson(e)).toList();
  }

  static Future<void> setPrefProjects(
      List<ScrapboxProjectPref> projects) async {
    final pref = await SharedPreferences.getInstance();

    pref.setString("projects", json.encode(projects));
  }

  static Future<SharedPreferences> getPrefs() {
    return SharedPreferences.getInstance();
  }
}
