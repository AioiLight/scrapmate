import 'package:flutter/widgets.dart';
import 'package:scrapmate/scrap.dart';

class Line extends StatefulWidget {
  Line({this.line});

  @override
  _LineState createState() => _LineState();

  final ScrapboxPageResult line;
}

class _LineState extends State<Line> with SingleTickerProviderStateMixin {
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
    return Container();
  }
}
