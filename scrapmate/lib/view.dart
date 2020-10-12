import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScrapView extends StatefulWidget {
  ScrapView({this.title, this.url});

  @override
  _ScrapViewState createState() => _ScrapViewState();

  final String title;
  final String url;
}

class _ScrapViewState extends State<ScrapView>
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
          title: Text(widget.title),
        ),
        body: Container(
          child: ListView(
            children: [SelectableText(widget.url)],
          ),
        ));
  }
}
