import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrapmate/view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static void openBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Unable to open browser");
    }
  }

  static void openScrapPage(
      BuildContext context, String title, String projectName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScrapView(
                  title: title,
                  projectName: projectName,
                )));
  }
}
