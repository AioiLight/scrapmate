import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/parser.dart';
import 'package:scrapmate/util.dart';
import 'package:share/share.dart';
import 'scrap.dart';

class ScrapView extends StatefulWidget {
  ScrapView({Key key}) : super(key: key);

  @override
  _ScrapViewState createState() => _ScrapViewState();
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

  void _openShare(ScrapViewArgs args) {
    Share.share(
        '${args.pageTitle} - ${Scrap.getPageUrl(args.projectDir, args.pageTitle)}');
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context).settings.arguments as ScrapViewArgs;

    _scrapboxPageResult =
        Scrap.getPage(Scrap.getJsonPages(args.projectDir, args.pageTitle));
    _scrapboxPageResult.then((value) => _loaded(value));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScrapViewArgs;

    return Scaffold(
        appBar: AppBar(
            title: Text(args.pageTitle),
            actions: [
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () => {_openShare(args)},
                tooltip: "Share",
              ),
              IconButton(
                icon: Icon(Icons.open_in_browser),
                onPressed: () => Util.openBrowser(
                    Scrap.getPageUrl(args.projectDir, args.pageTitle)),
                tooltip: "Open in browser",
              )
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName("/project"));
              },
            )),
        body: Container(
            child: _result != null
                ? ListView(
                    children: Parser.parse(_result, context, args.projectDir),
                    padding: Const.Edge,
                  )
                : Center(child: CircularProgressIndicator())));
  }
}

class ScrapViewArgs {
  ScrapViewArgs(this.pageTitle, this.projectDir);

  final String pageTitle;
  final String projectDir;
}
