import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/scrap.dart';
import 'package:scrapmate/util.dart';
import 'package:scrapmate/widgets/scrappage.dart';
import 'package:share/share.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage({Key key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Future<ScrapboxPageListResult> _items;
  List<ScrapboxPageListResultPage> _itemsResult;
  bool _loading = false;
  bool _allLoaded = false;
  bool _isWifi = false;
  bool _isInited = false;
  String _title;

  void _loaded(ScrapboxPageListResult result) {
    if (mounted) {
      setState(() {
        _itemsResult = result.pages;
      });

      _isInited = true;
    }
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

    if (mounted) {
      setState(() {
        _itemsResult.addAll(newPages);
      });
    }

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

    if (!_isInited) {
      final args = ModalRoute.of(context).settings.arguments as ProjectPageArgs;
      _items = Scrap.getProject(Scrap.getJsonUserTop(args.dir));
      _items.then((value) => _loaded(value));

      setState(() {
        _title = args.title;
      });
      Util.isUsingWiFi().then((value) => setState(() {
            _isWifi = value;
          }));

      Scrap.getProjectName(Scrap.getJsonProject(args.dir))
          .then((value) => setState(() => _title = value));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ProjectPageArgs;
    final imageSettings = PrefService.getInt("loadingImages");
    final showImage = imageSettings == 0 || (_isWifi && imageSettings == 1);

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => {_openShare(args)},
            tooltip: AppLocalizations.of(context).share,
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () =>
                Util.openBrowser(Scrap.getProjectUrl(args.dir), context),
            tooltip: AppLocalizations.of(context).open_in_browser,
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
                    key: PageStorageKey(index),
                    id: item.id,
                    title: item.title,
                    lead: item.descriptions.join("\n"),
                    thumbnail: item.image,
                    projectUrl: args.dir,
                    pin: item.pin > 0,
                    showImage: showImage,
                  );
                },
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class ProjectPageArgs {
  ProjectPageArgs(this.title, this.dir);

  final String title;
  final String dir;
}
