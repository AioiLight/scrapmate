import 'package:flutter/material.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/scrap.dart';
import 'package:scrapmate/widgets/project.dart';
import 'package:scrapmate/widgets/scrappage.dart';

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

  void loaded(List<ScrapboxPageListResultPage> result) {
    setState(() {
      _itemsResult = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _items = Scrap.getPages(Scrap.getJsonUserTop(widget.id));
    _items.then((value) => loaded(value));
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
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
          physics: Const.ListScrollPhysics,
          itemBuilder: (BuildContext context, int index) {
            if (_itemsResult == null) {
              return null;
            }
            final item = _itemsResult[index];
            return ScrapPage(
              id: item.id,
              title: item.title,
              lead: item.descriptions.join("\n"),
              thumbnail: item.image,
            );
          },
        ),
      ),
    );
  }
}
