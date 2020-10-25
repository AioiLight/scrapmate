import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/parser.dart';
import 'package:scrapmate/util.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
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

  void _openShare() {
    Share.share(
        '${widget.title} - ${Scrap.getPageUrl(widget.projectName, widget.title)}');
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
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: _openShare,
              tooltip: "Share",
            ),
            IconButton(
              icon: Icon(Icons.open_in_browser),
              onPressed: () => Util.openBrowser(
                  Scrap.getPageUrl(widget.projectName, widget.title)),
              tooltip: "Open in browser",
            )
          ],
        ),
        body: Container(
            child: _result != null
                ? ListView(
                    children: Parser.parse(_result),
                    padding: Const.Edge,
                  )
                : Center(child: CircularProgressIndicator())));
  }
}
