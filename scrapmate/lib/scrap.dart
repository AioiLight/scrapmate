import 'dart:convert';

import 'package:http/http.dart' as http;

class Scrap {
  static String getProjectUrl(String projectPath) {
    return "https://scrapbox.io/$projectPath/";
  }

  static Future<http.Response> fetch(String url,
      {Map<String, String> headers}) {
    return http.get(url, headers: headers);
  }

  static Future<Map<String, dynamic>> getJsonUserTop(String projectPath) async {
    final url = "https://scrapbox.io/api/pages/$projectPath";

    final response = await fetch(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> j = json.decode(response.body);
      return j;
    } else {
      throw Exception("Unable to get infomations.");
    }
  }

  static Future<String> getProjectName(String projectPath) async {
    final url = "https://scrapbox.io/api/projects/$projectPath";

    final response = await fetch(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> j = json.decode(response.body);
      return j['displayName'];
    } else {
      throw Exception("Unable to get infomations.");
    }
  }
}
