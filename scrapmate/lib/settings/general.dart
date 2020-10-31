import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsGeneral extends StatefulWidget {
  @override
  _SettingsGeneralState createState() => _SettingsGeneralState();
}

class _SettingsGeneralState extends State<SettingsGeneral>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
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
          DropdownPreference(AppLocalizations.of(context).settings_grid, "grid",
              desc: AppLocalizations.of(context).settings_grid_desc,
              defaultVal: 3,
              values: [1, 2, 3, 4, 5]),
          SwitchPreference(
              AppLocalizations.of(context).settings_telomere, "telomere",
              desc: AppLocalizations.of(context).settings_telomere_desc,
              defaultVal: true),
        ]));
  }
}
