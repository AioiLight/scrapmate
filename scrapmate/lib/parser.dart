import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:preferences/preference_service.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/widgets/telomere.dart';
import 'package:url_launcher/url_launcher.dart';
import 'scrap.dart';

class Parser {
  static List<Widget> parse(ScrapboxPageResult scrap) {
    final result = List<Widget>();

    // タイトル行スキップ
    final lines = scrap.lines.skip(1).toList();

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final text = line.text;

      var indent = _getIndent(line.text);

      ScrapLine l;

      if (text.trimLeft().startsWith("code:")) {
        // コードブロック
        final codes = _getUtilUnIndent(scrap, i, indent);
        i += codes.length - 1;

        l = ScrapCode(indent, line,
            lang: codes.first.text.substring("code:".length),
            codes: codes.skip(1).map((e) => e.text).toList());
      } else {
        // ただの段落。
        l = ScrapText(indent, line, text: text);
      }

      final lineWidget = l.generate();

      result.add(Stack(
        children: [
          if (PrefService.getBool("telomere"))
            Positioned(child: Telomere(l.info.updated), top: 0, bottom: 0),
          Row(
            children: [
              Container(
                width: 16 + 1.0 * indent * 8,
              ),
              lineWidget
            ],
          )
        ],
      ));
    }

    return result;
  }

  /// インデントが1段階下がるまでの行を抽出する。
  static List<ScrapboxPageResultLines> _getUtilUnIndent(
      ScrapboxPageResult list, int startIndex, int indent) {
    final remain = list.lines.skip(startIndex + 1).toList();

    for (var i = 1; i < remain.length; i++) {
      if (_getIndent(remain[i].text) == indent) {
        // 同じインデントの高さにぶち当たるまで
        return remain.take(i).toList();
      }
    }

    return remain.toList();
  }

  /// 現在のインデント量を求める。
  static int _getIndent(String str) {
    // スペースを除去するした文字列の長さと比較するとインデントの深さが分かる
    return str.length - str.trimLeft().length;
  }
}

abstract class ScrapLine {
  ScrapLine(this.level, this.info);

  Widget generate();

  final int level;
  final ScrapboxPageResultLines info;
}

class ScrapText extends ScrapLine {
  ScrapText(int level, ScrapboxPageResultLines info, {this.text})
      : super(level, info);

  final String text;

  List<TextSpan> _getSpan(String str, {TextStyle style}) {
    final list = List<TextSpan>();

    str = str.trim();

    while (str.length > 0) {
      // 正規表現でパターンマッチングして、最短位置の前までを抽出
      final deco = Scrap.decoration.firstMatch(str);
      final link = Scrap.link.firstMatch(str);

      if (deco == null && link == null) {
        list.add(TextSpan(text: str, style: style));
        print("普通の文字: $str");
        str = "";
        continue;
      }

      final matches = {deco, link};
      final sorted = matches.where((element) => element != null).toList();
      sorted.sort((a, b) => a.start.compareTo(b.start));

      final first = sorted.first;

      if (first.start > 0) {
        // プレーンテキストがある
        list.add(TextSpan(text: str.substring(0, first.start), style: style));
        str = str.substring(first.start);
      } else {
        // 装飾・リンクなど
        if (first == deco) {
          // 装飾
          final style = _getParseText(_getDecorations(deco.group(1)));

          list.add(TextSpan(children: _getSpan(deco.group(2), style: style)));
          print("装飾: ${deco.group(2)}");
        } else if (first == link) {
          // リンク
          final content = link.group(1) + link.group(2);
          final url = Scrap.url.firstMatch(content);
          final titled = Scrap.titledLink.firstMatch(content);

          TextSpan span;

          final style = TextStyle(
              color: Colors.accents.first,
              decoration: TextDecoration.underline);

          if (titled != null) {
            final before = Scrap.url.hasMatch(titled.group(1));
            final after = Scrap.url.hasMatch(titled.group(2));

            if (before && after) {
              // 前も後ろもリンクっぽい = 前がリンクになる
              span = TextSpan(
                  text: titled.group(2),
                  style: style,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openBrowser(titled.group(1)));
            } else if (after) {
              // 後ろがリンクっぽい = 後ろがリンクになる
              span = TextSpan(
                  text: titled.group(1),
                  style: style,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openBrowser(titled.group(2)));
            } else if (before) {
              // 前がリンクっぽい = 前がリンクになる
              span = TextSpan(
                  text: titled.group(2),
                  style: style,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openBrowser(titled.group(1)));
            }
          } else if (url != null) {
            span = TextSpan(
                text: url.input,
                style: style,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _openBrowser(url.input));
          } else {
            span = TextSpan(
                children:
                    _getSpan(link.group(1) + link.group(2), style: style));
          }

          if (span != null) {
            list.add(span);
            print("リンク: ${link.group(1)}");
          }
        }
        str = str.substring(first.end);
      }
    }

    return list;
  }

  TextStyle _getParseText(Decorations d) {
    var fontWeight = FontWeight.normal;
    var fontStyle = FontStyle.normal;
    var fontSize = Const.defaultFontSize;
    var decoration = TextDecoration.none;

    if (d.strong > 0) {
      fontWeight = FontWeight.bold;
      if (d.strong > 1) {
        // ** 以上は文字をでかくする
        fontSize += (d.strong - 1) * 4;
      }
    }
    if (d.italic > 0) {
      fontStyle = FontStyle.italic;
    }
    if (d.strike > 0) {
      decoration = TextDecoration.lineThrough;
    }

    return TextStyle(
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        fontSize: fontSize,
        decoration: decoration);
  }

  Decorations _getDecorations(String deco) {
    final d = Decorations();

    deco.split("").forEach((element) {
      switch (element) {
        case "*":
          d.strong++;
          break;
        case "/":
          d.italic++;
          break;
        case "-":
          d.strike++;
          break;
        default:
          break;
      }
    });

    return d;
  }

  void _openBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Unable to open browser");
    }
  }

  Widget generate() {
    return Flexible(
        child: SelectableText.rich(
      TextSpan(children: _getSpan(text)),
      style: TextStyle(height: 1.8),
    ));
  }
}

class ScrapCode extends ScrapLine {
  ScrapCode(int level, ScrapboxPageResultLines info, {this.lang, this.codes})
      : super(level, info);

  final String lang;
  final List<String> codes;

  Widget generate() {
    final md = "```$lang\n" + codes.join("\n") + "\n```";
    return Flexible(child: MarkdownBody(data: md, selectable: true));
  }
}

class Decorations {
  int strong = 0;
  int italic = 0;
  int strike = 0;
}
