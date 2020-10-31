import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrapmate/projectPage.dart';
import 'package:scrapmate/view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'scrap.dart';

class Util {
  static Future<bool> isUsingWiFi() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

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

  static void showToast(String mes) async {
    Fluttertoast.showToast(msg: mes);
  }

  static void openBrowser(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showToast(AppLocalizations.of(context).open_in_browser_failed);
    }
  }

  static void openProjectPage(
      BuildContext context, String title, String projectDir) {
    Navigator.pushNamed(context, "/project",
        arguments: ProjectPageArgs(title, projectDir));
  }

  static void openScrapPage(
      BuildContext context, String title, String projectDir) {
    Navigator.pushNamed(context, "/view",
        arguments: ScrapViewArgs(title, projectDir));
  }
}
