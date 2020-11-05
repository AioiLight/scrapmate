import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:preferences/preference_service.dart';
import 'package:scrapmate/parser.dart';
import 'package:scrapmate/util.dart';
import 'package:share/share.dart';
import 'scrap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool _isWifi;

  void _loaded(ScrapboxPageResult result) {
    if (mounted) {
      setState(() {
        _result = result;
      });
    }
  }

  void _openShare(ScrapViewArgs args) {
    final title = args.pageTitle;
    final pageUrl =
        Scrap.getPageUrl(args.projectDir, Util.urlEncode(args.pageTitle));
    Share.share('$title - $pageUrl');
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

    Util.isUsingWiFi().then((value) => setState(() {
          _isWifi = value;
        }));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScrapViewArgs;
    final imageSettings = PrefService.getInt("loadingImages");
    final showImage = imageSettings == 0 || (_isWifi && imageSettings == 1);

    return Scaffold(
        key: widget.key,
        appBar: AppBar(
          title: Text(args.pageTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => {_openShare(args)},
              tooltip: AppLocalizations.of(context).share,
            ),
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: () => Util.openBrowser(
                  Scrap.getPageUrl(args.projectDir, args.pageTitle), context),
              tooltip: AppLocalizations.of(context).open_in_browser,
            )
          ],
        ),
        body: Container(
            child: _result != null
                ? FutureBuilder(
                    future: Parser.parse(
                        _result, context, args.projectDir, showImage),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Widget>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: snapshot.data,
                          padding: const EdgeInsets.only(right: 24),
                        );
                      } else {
                        return Center(
                            child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            const Flexible(child: Text("Loading..."))
                          ],
                          mainAxisSize: MainAxisSize.min,
                        ));
                      }
                    },
                  )
                : const Center(child: CircularProgressIndicator())));
  }
}

class ScrapViewArgs {
  ScrapViewArgs(this.pageTitle, this.projectDir);

  final String pageTitle;
  final String projectDir;
}
