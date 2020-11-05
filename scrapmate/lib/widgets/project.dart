import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrapmate/projectPage.dart';
import 'package:scrapmate/scrap.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Project extends StatefulWidget {
  Project({this.projectName, this.icon, this.path, this.key});

  final String projectName;
  final String icon;
  final String path;
  final Key key;

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
        child: ListTile(
            leading: widget.icon != null
                ? CachedNetworkImage(
                    imageUrl: widget.icon,
                    width: 64,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 64))
                : const Icon(Icons.error, size: 64),
            title: Text(widget.projectName),
            subtitle: Text(Scrap.getProjectUrl(widget.path)),
            onTap: () => {
                  Navigator.pushNamed(context, "/project",
                      arguments:
                          ProjectPageArgs(widget.projectName, widget.path))
                }));
  }
}
