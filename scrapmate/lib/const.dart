import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Const {
  static const String AppName = "ScrapMate";

  static const EdgeInsets Edge = EdgeInsets.all(10.0);

  static double defaultFontSize;

  static const ScrollPhysics ListScrollPhysics =
      AlwaysScrollableScrollPhysics();

  static final ThemeData blackTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.black,
    dialogBackgroundColor: Colors.black,
    dialogTheme: DialogTheme(backgroundColor: Colors.black),
    appBarTheme: AppBarTheme(color: Colors.black),
    bottomAppBarColor: Colors.black,
    backgroundColor: Colors.black,
    brightness: Brightness.dark,
  );
}
