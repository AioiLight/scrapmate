import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/scrap.dart';

class ScrapPage extends StatefulWidget {
  ScrapPage({this.title, this.lead, this.thumbnail, this.id});

  final String title;
  final String lead;
  final String thumbnail;
  final String id;

  @override
  _ScrapPageState createState() => _ScrapPageState();
}

class _ScrapPageState extends State<ScrapPage>
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
    return Card(
      child: Container(
          margin: Const.Edge,
          child: Column(
            children: [
              ListTile(
                leading: widget.thumbnail != null
                    ? Image.network(widget.thumbnail)
                    : Icon(Icons.error),
                title: Text(widget.title),
                subtitle: Text(widget.lead),
              )
            ],
          )),
    );
  }
}
