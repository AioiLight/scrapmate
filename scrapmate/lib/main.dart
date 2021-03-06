import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:preferences/preferences.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/projectPage.dart';
import 'package:scrapmate/scrap.dart';
import 'package:scrapmate/settings/general.dart';
import 'package:scrapmate/util.dart';
import 'package:scrapmate/view.dart';
import 'package:scrapmate/widgets/addProjectDialog.dart';
import 'package:scrapmate/widgets/project.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  PrefService.setDefaultValues({
    "theme": 0,
    "blackTheme": false,
    "grid": 3,
    "telomere": true,
    "loadingImages": 0
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeInt = PrefService.getInt("theme");

    Const.defaultFontSize = Theme.of(context).textTheme.bodyText1.fontSize;

    var themeMode = ThemeMode.system;

    if (themeInt == 1) {
      themeMode = ThemeMode.light;
    } else if (themeInt == 2) {
      themeMode = ThemeMode.dark;
    }

    return MaterialApp(
      title: Const.AppName,
      theme: ThemeData.light(),
      darkTheme: PrefService.getBool("blackTheme") ?? false
          ? Const.blackTheme
          : ThemeData.dark(),
      themeMode: themeMode,
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => MyHomePage(title: Const.AppName),
        "/project": (BuildContext context) => ProjectPage(),
        "/view": (BuildContext context) => ScrapView(),
        "/setting": (BuildContext context) => SettingsGeneral(),
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  var _list = List<ScrapboxProjectPref>();
  bool _inited = false;

  void _onReorder(int oldIndex, int newIndex) {
    if (mounted) {
      setState(
        () {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = _list.removeAt(oldIndex);
          _list.insert(newIndex, item);
        },
      );
    }

    Util.setPrefProjects(_list);
  }

  void _pushedAddProject() async {
    final result = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AddProjectDialog().showDialog(context);
        });

    if (result != null) {
      _addProject(result);
    }
  }

  void _loadProject() async {
    final pref = await Util.getPrefProjects();
    if (mounted) {
      setState(() {
        _list = pref;
      });
    }
  }

  Future<Null> _processInitalLink(BuildContext context) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();

      if (initialLink == null) {
        return;
      }
      _openLink(initialLink, context);
    } on PlatformException {}

    getLinksStream().listen((String link) {
      _openLink(link, context);
    }, onError: (err) {});
    _inited = true;
  }

  void _openLink(String initialLink, BuildContext context) {
    final project = Scrap.scrapboxProject.firstMatch(initialLink);
    final page = Scrap.scrapboxPage.firstMatch(initialLink);

    if (page != null) {
      if (Scrap.nonPageUrl.hasMatch(page.group(1) + "/" + page.group(2))) {
        Util.showToast(AppLocalizations.of(context).scrap_invalid_url);
        return;
      }

      Util.openProjectPage(context, page.group(1).replaceAll("/", ""),
          page.group(1).replaceAll("/", ""));
      Util.openScrapPage(
          context,
          Util.urlDecode(page.group(2).replaceAll("/", "")),
          page.group(1).replaceAll("/", ""));
    } else if (project != null) {
      if (Scrap.nonProjectUrl.hasMatch(project.group(1))) {
        Util.showToast(AppLocalizations.of(context).scrap_invalid_url);
        return;
      }

      Util.openProjectPage(context, project.group(1).replaceAll("/", ""),
          project.group(1).replaceAll("/", ""));
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _loadProject();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_inited) {
      _processInitalLink(context);
    }
  }

  void _addProject(String projectURL) async {
    try {
      final projectJson = Scrap.getJsonProject(projectURL);
      final screenName = await Scrap.getProjectName(projectJson);

      if (screenName == null) {
        // エラー
        final error = await Scrap.getError(projectJson);

        if (error.statusCode == 404) {
          // 見つからない
          Util.showToast(AppLocalizations.of(context).scrap_404);
        } else if (error.statusCode == 403 || error.statusCode == 401) {
          // プライベート
          Util.showToast(AppLocalizations.of(context).scrap_403);
        } else {
          Util.showToast(AppLocalizations.of(context).scrap_network_error);
        }

        return;
      }
      final icon = await Scrap.getProjectIcon(projectJson);
      final url = projectURL;

      final item =
          ScrapboxProjectPref(projectName: screenName, icon: icon, path: url);

      final pref = await Util.getPrefProjects();
      pref.add(item);

      if (mounted) {
        setState(() {
          _list = pref;
        });
      }

      Util.setPrefProjects(pref);

      Util.showToast(
          AppLocalizations.of(context).project_added(item.projectName));
    } catch (e) {
      Util.showToast(AppLocalizations.of(context).scrap_network_error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: const Icon(Icons.settings),
              tooltip: AppLocalizations.of(context).settings,
              onPressed: () {
                Navigator.pushNamed(context, "/setting");
              })
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: constraints.maxHeight),
              child: ReorderableListView(
                  scrollDirection: Axis.vertical,
                  onReorder: _onReorder,
                  children: List.generate(_list?.length, (index) {
                    if (_list == null) {
                      return null;
                    }
                    final item = _list[index];
                    return Dismissible(
                      key: Key(item.projectName),
                      child: Project(
                        projectName: item?.projectName ?? "Unknown project",
                        icon: item?.icon ?? null,
                        path: item?.path ?? "-",
                        key: Key(index.toString()),
                      ),
                      onDismissed: (direction) {
                        if (mounted) {
                          setState(() {
                            _list.removeAt(index);
                          });
                        }

                        Util.setPrefProjects(_list);

                        Util.showToast(AppLocalizations.of(context)
                            .project_removed(item.projectName));
                      },
                    );
                  }))),
          physics: Const.ListScrollPhysics,
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushedAddProject,
        tooltip: AppLocalizations.of(context).add_project,
        child: const Icon(Icons.add),
      ),
    );
  }
}
