import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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

        l = ScrapCode(indent,
            lang: codes.first.text.substring("code:".length),
            codes: codes.skip(1).map((e) => e.text).toList());
      } else {
        // ただの段落。
        l = ScrapText(indent, text: text);
      }

      result.add(l.generate());
    }

    return result;
  }

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

  static int _getIndent(String str) {
    // スペースを除去するした文字列の長さと比較するとインデントの深さが分かる
    return str.length - str.trimLeft().length;
  }
}

abstract class ScrapLine {
  ScrapLine({this.level});

  Widget generate();

  final int level;
}

class ScrapText extends ScrapLine {
  ScrapText(int level, {this.text}) : super(level: level);

  final String text;

  Widget generate() {
    return Text(text);
  }
}

class ScrapCode extends ScrapLine {
  ScrapCode(int level, {this.lang, this.codes}) : super(level: level);

  final String lang;
  final List<String> codes;

  Widget generate() {
    final md = "```$lang\n" + codes.join("\n") + "\n```";
    return MarkdownBody(data: md, selectable: true);
  }
}
