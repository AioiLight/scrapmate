import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'scrap.dart';

class ScrapView extends StatefulWidget {
  ScrapView({this.title, this.projectName});

  @override
  _ScrapViewState createState() => _ScrapViewState();

  final String title;
  final String projectName;
}

class _ScrapViewState extends State<ScrapView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Future<ScrapboxPageResult> _scrapboxPageResult;
  ScrapboxPageResult _result;

  void _loaded(ScrapboxPageResult result) {
    setState(() {
      _result = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _scrapboxPageResult =
        Scrap.getPage(Scrap.getJsonPages(widget.projectName, widget.title));
    _scrapboxPageResult.then((value) => _loaded(value));
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
            child: _result != null
                ? ListView(
                    children: [
                      SelectableText(
                          _result.lines.map((e) => e.text).join("\n"))
                    ],
                  )
                : Center(child: CircularProgressIndicator())));
  }
}
