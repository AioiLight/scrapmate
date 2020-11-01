import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:preferences/preference_service.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/gyazo.dart';
import 'package:scrapmate/util.dart';
import 'package:scrapmate/widgets/telomere.dart';
import 'package:syntax_highlighter/syntax_highlighter.dart';
import 'scrap.dart';

class Parser {
  static Future<List<Widget>> parse(ScrapboxPageResult scrap,
      BuildContext context, String projectDir, bool showImage) async {
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

        l = ScrapCode(indent, line, context, projectDir,
            lang: codes.first.text.trim().substring("code:".length),
            codes: codes.skip(1).map((e) => e.text).toList());
      } else if (text.trimLeft().startsWith("table:")) {
        // テーブル
        final table = _getUtilUnIndent(scrap, i, indent);
        i += table.length - 1;

        l = ScrapTable(indent, line, context, projectDir,
            rows: table.skip(1).map((e) => e.text.trim()).toList(),
            title: table.first.text.trim().substring("table:".length));
      } else if (text.trimLeft().startsWith(">")) {
        l = ScraoQuote(indent, line, context, projectDir,
            content: text.trimLeft().substring(">".length));
      } else {
        // ただの段落。
        l = ScrapText(indent, line, context, projectDir, text: text);
      }

      final lineWidget = l.generate();

      result.add(Column(
        children: [
          Stack(
            children: [
              if (PrefService.getBool("telomere"))
                Positioned(child: Telomere(l.info.updated), top: 0, bottom: 0),
              Row(
                children: [
                  Container(
                    width: 24 + 1.0 * indent * 8,
                  ),
                  Expanded(child: await lineWidget)
                ],
              )
            ],
          ),
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
      if (_getIndent(remain[i].text) <= indent) {
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
  ScrapLine(this.level, this.info, this.context, this.projectDir);

  Future<Widget> generate();

  final int level;
  final ScrapboxPageResultLines info;
  final BuildContext context;
  final String projectDir;
}

class ScrapText extends ScrapLine {
  ScrapText(int level, ScrapboxPageResultLines info, BuildContext context,
      String projectDir,
      {this.text})
      : super(level, info, context, projectDir);

  final String text;
  final linkStyle = TextStyle(
      color: Colors.accents.first, decoration: TextDecoration.underline);

  Future<List<TextSpan>> _getSpan(String str, {TextStyle style}) async {
    final list = List<TextSpan>();

    str = str.trim();

    while (str.length > 0) {
      // 正規表現でパターンマッチングして、最短位置の前までを抽出
      final deco = Scrap.decoration.firstMatch(str);
      final bracketLink = Scrap.link.firstMatch(str);
      final plainLink = Scrap.url.firstMatch(str);
      final inlineCode = Scrap.inlineCode.firstMatch(str);

      if (deco == null &&
          bracketLink == null &&
          plainLink == null &&
          inlineCode == null) {
        list.add(TextSpan(text: str, style: style));
        str = "";
        continue;
      }

      final matches = {deco, bracketLink, plainLink, inlineCode};
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
          final style = _getParseText(_getDecorations(deco.namedGroup("type")));

          list.add(TextSpan(
              children:
                  await _getSpan(deco.namedGroup("content"), style: style)));
        } else if (first == bracketLink) {
          // リンク
          final content = bracketLink.group(1) + bracketLink.group(2);
          final url = Scrap.url.firstMatch(content);
          final titled = Scrap.titledLink.firstMatch(content);
          final icon = Scrap.icon.firstMatch(content);

          TextSpan span;

          final style = linkStyle;

          if (titled != null) {
            final before = Scrap.url.hasMatch(titled.group(1));
            final after = Scrap.url.hasMatch(titled.group(2));

            var text = "";
            var url = "";

            if (before && after) {
              // 前も後ろもリンクっぽい = 前がリンクになる
              text = titled.group(2);
              url = titled.group(1);
            } else if (after) {
              // 後ろがリンクっぽい = 後ろがリンクになる
              text = titled.group(1);
              url = titled.group(2);
            } else if (before) {
              // 前がリンクっぽい = 前がリンクになる
              text = titled.group(2);
              url = titled.group(1);
            } else {
              // どちらもリンクじゃない = スペースのある内部リンク
              span = _getInternalLinkSpan(content, style, context, projectDir);
            }
            if (before || after) {
              final gyazo = Scrap.gyazo.firstMatch(text);
              if (gyazo != null) {
                span = TextSpan(
                  children: [
                    WidgetSpan(
                        child: InkWell(
                            child: CachedNetworkImage(imageUrl: text),
                            onTap: () => Util.openBrowser(url, context)))
                  ],
                );
              } else {
                span = TextSpan(
                    text: text,
                    style: style,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Util.openBrowser(url, context));
              }
            }
          } else if (url != null) {
            final gyazo = Scrap.gyazo.firstMatch(url.input);
            if (gyazo != null) {
              final ftr = Gyazo.getGyazoImage(url.input);
              span = TextSpan(
                children: [WidgetSpan(child: CachedGyazoImage(ftr))],
              );
            } else {
              span = TextSpan(
                  text: url.input,
                  style: style,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Util.openBrowser(url.input, context));
            }
          } else if (icon != null) {
            final herf = Scrap.getIconUrl(projectDir, icon.group(1));
            span = TextSpan(
              children: [
                WidgetSpan(
                    child: InkWell(
                        child: CachedNetworkImage(
                          imageUrl: herf,
                          width: Const.defaultFontSize,
                        ),
                        onTap: () => Util.openScrapPage(
                            context, projectDir, icon.group(1))))
              ],
            );
          } else {
            span = _getInternalLinkSpan(content, style, context, projectDir);
          }

          if (span != null) {
            list.add(span);
          }
        } else if (first == plainLink) {
          // プレーンなリンク
          final url = str.substring(first.start, first.end);
          list.add(TextSpan(
              text: url,
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () => Util.openBrowser(url, context)));
        } else if (first == inlineCode) {
          // インラインコード
          final code = inlineCode.group(1);
          final SyntaxHighlighterStyle style =
              Theme.of(context).brightness == Brightness.dark
                  ? SyntaxHighlighterStyle.darkThemeStyle()
                  : SyntaxHighlighterStyle.lightThemeStyle();
          list.add(TextSpan(
            style: const TextStyle(),
            children: <TextSpan>[
              DartSyntaxHighlighter(style).format(code),
            ],
          ));
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

  TextSpan _getInternalLinkSpan(String content, TextStyle style,
      BuildContext context, String projectDir) {
    return TextSpan(
      text: content,
      style: style,
      recognizer: TapGestureRecognizer()
        ..onTap = () => Util.openScrapPage(context, content, projectDir),
    );
  }

  Future<Widget> generate() async {
    return RichText(
        text: TextSpan(
      children: await _getSpan(text),
      style: TextStyle(height: 1.8),
    ));
  }
}

class ScrapCode extends ScrapLine {
  ScrapCode(int level, ScrapboxPageResultLines info, BuildContext context,
      String projectDir,
      {this.lang, this.codes})
      : super(level, info, context, projectDir);

  final String lang;
  final List<String> codes;

  Future<Widget> generate() async {
    final md = "```$lang\n" + codes.join("\n") + "\n```";
    return Column(children: [
      Row(
        children: [
          Icon(Icons.code),
          Text(lang),
        ],
      ),
      MarkdownBody(
        data: md,
        selectable: true,
        fitContent: false,
      )
    ]);
  }
}

class ScrapTable extends ScrapLine {
  ScrapTable(int level, ScrapboxPageResultLines info, BuildContext context,
      String projectDir,
      {this.rows, this.title})
      : super(level, info, context, projectDir);

  TableRow _getRow(
    String row,
  ) {
    final list = List<Text>();

    row.split("\t").forEach((element) {
      list.add(Text(element));
    });

    return TableRow(
        children: list,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor));
  }

  Table _getTable(List<String> rows) {
    return Table(children: rows.map((e) => _getRow(e)).toList());
  }

  Future<Widget> generate() async {
    return Column(children: [
      Row(children: [Icon(Icons.table_view), Text(title ?? "")]),
      _getTable(rows)
    ]);
  }

  final List<String> rows;
  final String title;
}

class ScraoQuote extends ScrapLine {
  ScraoQuote(int level, ScrapboxPageResultLines info, BuildContext context,
      String projectDir,
      {this.content})
      : super(level, info, context, projectDir);

  Future<Widget> generate() async {
    return Container(
      child: Stack(
        children: [
          await ScrapText(level, info, context, projectDir,
                  text: content.substring(1))
              .generate(),
          Positioned(
            top: 0,
            right: 0,
            child: Icon(Icons.format_quote),
          )
        ],
      ),
      color: Theme.of(context).primaryColor,
    );
  }

  final String content;
}

class Decorations {
  int strong = 0;
  int italic = 0;
  int strike = 0;
}

class CachedGyazoImage extends StatelessWidget {
  CachedGyazoImage(this.oEmbedResult);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: oEmbedResult,
      builder: (context, AsyncSnapshot<GyazoOEmbedResult> snapshot) {
        if (snapshot.hasData) {
          return InkWell(
              child: CachedNetworkImage(imageUrl: snapshot.data.url),
              onTap: () => Util.openBrowser(snapshot.data.url, context));
        } else {
          return Container();
        }
      },
    );
  }

  final Future<GyazoOEmbedResult> oEmbedResult;
}
