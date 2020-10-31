import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Telomere extends StatelessWidget {
  Telomere(this.time);

  final int time;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = (0.001 * now.millisecondsSinceEpoch - time);

    var width = 1;

    if (diff > 60 * 60 * 24 * 365) {
      // 1年
      width = 2;
    } else if (diff > 60 * 60 * 24 * 180) {
      // 180日
      width = 3;
    } else if (diff > 60 * 60 * 24 * 90) {
      // 90日
      width = 4;
    } else if (diff > 60 * 60 * 24 * 60) {
      // 60日
      width = 5;
    } else if (diff > 60 * 60 * 24 * 30) {
      // 30日
      width = 6;
    } else if (diff > 60 * 60 * 24 * 7) {
      // 7日
      width = 7;
    } else if (diff > 60 * 60 * 72) {
      // 72時間
      width = 8;
    } else if (diff > 60 * 60 * 24) {
      // 24時間
      width = 9;
    } else if (diff > 60 * 60 * 12) {
      // 12時間
      width = 10;
    } else if (diff > 60 * 60 * 8) {
      // 8時間
      width = 11;
    } else if (diff > 60 * 60 * 6) {
      // 6時間
      width = 12;
    } else if (diff > 60 * 60 * 2) {
      // 2時間
      width = 13;
    } else if (diff > 60 * 60) {
      // 1時間
      width = 14;
    } else {
      // 0時間
      width = 15;
    }
    return Container(
      color: Colors.green,
      width: 1.0 * width,
    );
  }
}
