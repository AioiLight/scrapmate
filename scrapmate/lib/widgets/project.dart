import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/util.dart';

class Project extends StatefulWidget {
  Project({this.name, this.path});

  final String name;
  final String path;

  @override
  _ProjectState createState() => _ProjectState();
}

class _ProjectState extends State<Project> with SingleTickerProviderStateMixin {
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
    return Card(
        child: Container(
            margin: Const.Edge,
            child: Column(
              children: [
                ListTile(
                  title: Text(widget.name),
                  subtitle: Text(Util.getUrl(widget.path)),
                )
              ],
            )));
  }
}
