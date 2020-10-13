import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:preferences/preferences.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/scrap.dart';
import 'package:scrapmate/settings/general.dart';
import 'package:scrapmate/util.dart';
import 'package:scrapmate/widgets/addProjectDialog.dart';
import 'package:scrapmate/widgets/project.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeInt = PrefService.getInt("theme");

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
      home: MyHomePage(title: Const.AppName),
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

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final item = _list.removeAt(oldIndex);
        _list.insert(newIndex, item);
      },
    );

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
    setState(() {
      _list = pref;
    });
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

  void _addProject(String projectURL) async {
    final projectJson = Scrap.getJsonProject(projectURL);
    final screenName = await Scrap.getProjectName(projectJson);
    final icon = await Scrap.getProjectIcon(projectJson);
    final url = projectURL;

    final item =
        ScrapboxProjectPref(projectName: screenName, icon: icon, path: url);

    final pref = await Util.getPrefProjects();
    pref.add(item);

    setState(() {
      _list = pref;
    });

    Util.setPrefProjects(pref);
    Fluttertoast.showToast(msg: "Added ${item.projectName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsGeneral()));
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
                    return Project(
                      projectName: item?.projectName ?? "Unknown project",
                      icon: item?.icon ?? null,
                      path: item?.path ?? "-",
                      key: Key(index.toString()),
                    );
                  }))),
          physics: Const.ListScrollPhysics,
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushedAddProject,
        tooltip: 'Add project',
        child: Icon(Icons.add),
      ),
    );
  }
}
