import 'dart:convert';
import 'package:http/http.dart' as http;

class Gyazo {
  static Future<Map<String, dynamic>> getOEmbed(String url) async {
    final uri = Uri.https("api.gyazo.com", "/api/oembed", {"url": url});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  static Future<GyazoOEmbedResult> getGyazoImage(String url) async {
    final gyazo = await getOEmbed(url);

    if (gyazo != null) {
      return GyazoOEmbedResult.fromJson(gyazo);
    } else {
      return null;
    }
  }
}

class GyazoOEmbedResult {
  GyazoOEmbedResult(
      {this.version,
      this.type,
      this.providerName,
      this.providerUrl,
      this.url,
      this.width,
      this.height});

  final String version;
  final String type;
  final String providerName;
  final String providerUrl;
  final String url;
  final int width;
  final int height;

  factory GyazoOEmbedResult.fromJson(Map<String, dynamic> json) {
    return GyazoOEmbedResult(
        version: json["version"],
        type: json["type"],
        providerName: json["provider_name"],
        providerUrl: json["provider_url"],
        url: json["url"],
        width: json["width"],
        height: json["height"]);
  }
}
