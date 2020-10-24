import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:preferences/preferences.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/scrap.dart';
import 'package:scrapmate/util.dart';
import 'package:scrapmate/widgets/scrappage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage({Key key, this.title, this.id}) : super(key: key);

  final String title;
  final String id;

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Future<List<ScrapboxPageListResultPage>> _items;
  List<ScrapboxPageListResultPage> _itemsResult;
  bool _loading = false;

  void _loaded(List<ScrapboxPageListResultPage> result) {
    setState(() {
      _itemsResult = result;
    });
  }

  Future<void> _loadmore() async {
    if (_loading) {
      return null;
    }

    _loading = true;

    final newPages = await Scrap.getPages(
        Scrap.getJsonUserTop(widget.id, skip: _itemsResult.length));

    setState(() {
      _itemsResult.addAll(newPages);
    });

    _loading = false;
  }

  void _openShare() {
    Share.share('${widget.title} - ${Scrap.getProjectUrl(widget.id)}');
  }

  void _openBrowser() async {
    final url = Scrap.getProjectUrl(widget.id);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Unable to open browser");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _items = Scrap.getPages(Scrap.getJsonUserTop(widget.id));
    _items.then((value) => _loaded(value));
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
            onPressed: _openBrowser,
            tooltip: "Open in browser",
          )
        ],
      ),
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: GridView.builder(
          physics: Const.ListScrollPhysics,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: PrefService.getInt("grid")),
          itemBuilder: (BuildContext context, int index) {
            if (_itemsResult == null) {
              return null;
            }

            if (index == _itemsResult.length) {
              _loadmore();
              return const CircularProgressIndicator();
            }

            if (index > _itemsResult.length) {
              return null;
            }

            final item = _itemsResult[index];
            return ScrapPage(
              id: item.id,
              title: item.title,
              lead: item.descriptions.join("\n"),
              thumbnail: item.image,
              projectUrl: widget.id,
            );
          },
        ),
      ),
    );
  }
}
