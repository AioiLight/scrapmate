import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:scrapmate/const.dart';

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
          title: Text("Settings"),
        ),
        body: PreferencePage([
          PreferenceTitle("Looks"),
          DropdownPreference("Theme", "theme",
              desc: "ScrapMate's theme",
              defaultVal: 0,
              displayValues: ["Follow system", "Light", "Dark"],
              values: [0, 1, 2]),
          SwitchPreference("Black theme", "blackTheme",
              desc: "Use pure black background color when using dark theme",
              defaultVal: false),
          DropdownPreference("Number of grid columns", "grid",
              desc: "Number of grid columns in project page",
              defaultVal: 3,
              values: [1, 2, 3, 4, 5]),
        ]));
  }
}
