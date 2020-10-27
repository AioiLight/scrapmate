import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/scrap.dart';
import 'package:scrapmate/util.dart';
import 'package:scrapmate/widgets/scrappage.dart';
import 'package:share/share.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage({Key key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Future<List<ScrapboxPageListResultPage>> _items;
  List<ScrapboxPageListResultPage> _itemsResult;
  bool _loading = false;
  bool _allLoaded = false;

  void _loaded(List<ScrapboxPageListResultPage> result) {
    setState(() {
      _itemsResult = result;
    });
  }

  Future<void> _loadmore(ProjectPageArgs args) async {
    if (_loading) {
      return null;
    }

    _loading = true;

    final json = Scrap.getJsonUserTop(args.dir, skip: _itemsResult.length);

    final newPageResult = await Scrap.getProject(json);
    final newPages = await Scrap.getPages(json);

    if (_itemsResult.length >= newPageResult.count) {
      // 読み込みが全て終わった
      _allLoaded = true;
    }

    setState(() {
      _itemsResult.addAll(newPages);
    });

    _loading = false;
  }

  void _openShare(ProjectPageArgs args) {
    Share.share('${args.title} - ${Scrap.getProjectUrl(args.dir)}');
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context).settings.arguments as ProjectPageArgs;
    _items = Scrap.getPages(Scrap.getJsonUserTop(args.dir));
    _items.then((value) => _loaded(value));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ProjectPageArgs;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => {_openShare(args)},
            tooltip: "Share",
          ),
          IconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: () => Util.openBrowser(Scrap.getProjectUrl(args.dir)),
            tooltip: "Open in browser",
          )
        ],
      ),
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _itemsResult != null
            ? GridView.builder(
                physics: Const.ListScrollPhysics,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: PrefService.getInt("grid")),
                itemBuilder: (BuildContext context, int index) {
                  if (_itemsResult == null) {
                    return null;
                  }

                  if (index == _itemsResult.length) {
                    if (!_allLoaded) {
                      _loadmore(args);
                      return const CircularProgressIndicator();
                    } else {
                      return null;
                    }
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
                    projectUrl: args.dir,
                  );
                },
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class ProjectPageArgs {
  ProjectPageArgs(this.title, this.dir);

  final String title;
  final String dir;
}
