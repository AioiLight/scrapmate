import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:preferences/preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrapmate/util.dart';
import 'package:package_info/package_info.dart';

class SettingsGeneral extends StatefulWidget {
  @override
  _SettingsGeneralState createState() => _SettingsGeneralState();
}

class _SettingsGeneralState extends State<SettingsGeneral>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  String _version = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).settings),
        ),
        body: PreferencePage([
          PreferenceTitle(AppLocalizations.of(context).settings_looks),
          DropdownPreference(
              AppLocalizations.of(context).settings_theme, "theme",
              desc: AppLocalizations.of(context).settings_theme_desc,
              defaultVal: 0,
              displayValues: [
                AppLocalizations.of(context).settings_theme_default,
                AppLocalizations.of(context).settings_theme_light,
                AppLocalizations.of(context).settings_theme_dark
              ],
              values: [
                0,
                1,
                2
              ]),
          SwitchPreference(
              AppLocalizations.of(context).settings_black_theme, "blackTheme",
              desc: AppLocalizations.of(context).settings_black_theme_desc,
              defaultVal: false),
          PreferenceTitle(AppLocalizations.of(context).settings_scrapbox),
          DropdownPreference(
              AppLocalizations.of(context).settings_loading_images,
              "loadingImages",
              desc: AppLocalizations.of(context).settings_loading_images_desc,
              defaultVal: 0,
              displayValues: [
                AppLocalizations.of(context).settings_loading_images_always,
                AppLocalizations.of(context).settings_loading_images_wifi,
                AppLocalizations.of(context).settings_loading_images_never
              ],
              values: [
                0,
                1,
                2
              ]),
          if (Platform.isAndroid)
            ListTile(
              title: Text(AppLocalizations.of(context).settings_delete_cache),
              subtitle:
                  Text(AppLocalizations.of(context).settings_delete_cache_desc),
              onTap: () => {
                const AndroidIntent(
                  action: "action_application_details_settings",
                  data: "package:space.aioilight.scrapmate",
                ).launch()
              },
            ),
          DropdownPreference(AppLocalizations.of(context).settings_grid, "grid",
              desc: AppLocalizations.of(context).settings_grid_desc,
              defaultVal: 3,
              values: [1, 2, 3, 4, 5]),
          SwitchPreference(
              AppLocalizations.of(context).settings_telomere, "telomere",
              desc: AppLocalizations.of(context).settings_telomere_desc,
              defaultVal: true),
          PreferenceTitle(AppLocalizations.of(context).settings_scrapmate),
          ListTile(
            title: Text(AppLocalizations.of(context).settings_scrapmate_about),
            onTap: () => {
              showAboutDialog(
                  context: context,
                  applicationVersion: _version,
                  children: [
                    const Text("Powered by Flutter and Love <3"),
                    RaisedButton(
                      child: const Text("GitHub"),
                      onPressed: () => Util.openBrowser(
                          "https://github.com/AioiLight/scrapmate", context),
                    ),
                    RaisedButton(
                        child: const Text("Twitter (@aioilight)"),
                        onPressed: () => Util.openBrowser(
                            "https://twitter.com/aioilight/", context))
                  ],
                  applicationIcon: Container(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 64,
                      width: 64,
                    ),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ))
            },
          )
        ]));
  }
}
