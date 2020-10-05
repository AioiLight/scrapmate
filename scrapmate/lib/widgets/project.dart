import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/scrap.dart';

class Project extends StatefulWidget {
  Project({this.path});

  final String path;

  @override
  _ProjectState createState() => _ProjectState();
}

class _ProjectState extends State<Project> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Future<String> _displayName;
  Future<String> _icon;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    final result = Scrap.getJsonProject(widget.path);
    _displayName = Scrap.getProjectName(result);
    _icon = Scrap.getProjectIcon(result);
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
                  leading: FutureBuilder<String>(
                    future: _icon,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.network(snapshot.data);
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error);
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  title: FutureBuilder<String>(
                    future: _displayName,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Text("Loading...");
                    },
                  ),
                  subtitle: Text(Scrap.getProjectUrl(widget.path)),
                )
              ],
            )));
  }
}
