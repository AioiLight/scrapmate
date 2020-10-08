import 'dart:convert';

import 'package:http/http.dart' as http;

class Scrap {
  static String getProjectUrl(String projectPath) {
    return "https://scrapbox.io/$projectPath/";
  }

  static Future<http.Response> fetch(String path,
      {Map<String, String> params}) {
    final uri = Uri.https("scrapbox.io", path, params);
    return http.get(uri);
  }

  static Future<Map<String, dynamic>> getJsonUserTop(String projectPath,
      {int skip = 0, int limit = 20}) async {
    final url = "/api/pages/$projectPath";

    final response = await fetch(url,
        params: {'skip': skip.toString(), 'limit': limit.toString()});

    if (response.statusCode == 200) {
      final Map<String, dynamic> j = json.decode(response.body);
      return j;
    } else {
      throw Exception("Unable to get infomations.");
    }
  }

  static Future<Map<String, dynamic>> getJsonProject(String projectPath) async {
    final url = "/api/projects/$projectPath";

    final response = await fetch(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> j = json.decode(response.body);
      return j;
    } else {
      throw Exception("Unable to get infomations.");
    }
  }

  static Future<String> getProjectName(
      Future<Map<String, dynamic>> json) async {
    final name = await json;
    return name['displayName'];
  }

  static Future<String> getProjectIcon(
      Future<Map<String, dynamic>> json) async {
    final icon = await json;
    return icon['image'];
  }

  static Future<List<ScrapboxPageListResultPage>> getPages(
      Future<Map<String, dynamic>> json) async {
    final j = await json;
    final result = ScrapboxPageListResult.fromJson(j);

    return result.pages;
  }
}

class ScrapboxProjectPref {
  ScrapboxProjectPref({this.projectName, this.icon, this.path});

  final String projectName;
  final String icon;
  final String path;

  factory ScrapboxProjectPref.fromJson(Map<String, dynamic> json) {
    return ScrapboxProjectPref(
        projectName: json['projectName'],
        icon: json['icon'],
        path: json['url']);
  }

  Map<String, dynamic> toJson() =>
      {'projectName': projectName, 'icon': icon, 'url': path};
}

class ScrapboxPageListResult {
  ScrapboxPageListResult(
      {this.projectName, this.skip, this.limit, this.count, this.pages});

  final String projectName;
  final int skip;
  final int limit;
  final int count;
  final List<ScrapboxPageListResultPage> pages;

  factory ScrapboxPageListResult.fromJson(Map<String, dynamic> json) {
    var pageList = json['pages'] as List;
    return ScrapboxPageListResult(
      projectName: json['projectName'],
      skip: json['skip'],
      limit: json['limit'],
      count: json['count'],
      pages:
          pageList.map((e) => ScrapboxPageListResultPage.fromJson(e)).toList(),
    );
  }
}

class ScrapboxPageListResultId {
  ScrapboxPageListResultId({this.id});
  final String id;

  factory ScrapboxPageListResultId.fromJson(Map<String, dynamic> json) {
    return ScrapboxPageListResultId(id: json['id']);
  }
}

class ScrapboxPageListResultPage {
  ScrapboxPageListResultPage(
      {this.id,
      this.title,
      this.image,
      this.descriptions,
      this.user,
      this.pin,
      this.views,
      this.linked,
      this.commitId,
      this.created,
      this.updated,
      this.accessed,
      this.snapshotCreated});

  final String id;
  final String title;
  final String image;
  final List<String> descriptions;
  final ScrapboxPageListResultId user;
  final int pin;
  final int views;
  final int linked;
  final String commitId;
  final int created;
  final int updated;
  final int accessed;
  final int snapshotCreated;

  factory ScrapboxPageListResultPage.fromJson(Map<String, dynamic> json) {
    return ScrapboxPageListResultPage(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      descriptions: List<String>.from(json['descriptions']),
      user: ScrapboxPageListResultId.fromJson(json['user']),
      pin: json['pin'],
      views: json['views'],
      linked: json['linked'],
      commitId: json['commitId'],
      created: json['created'],
      updated: json['updated'],
      accessed: json['accessed'],
      snapshotCreated: json['snapshotCreated'],
    );
  }
}
