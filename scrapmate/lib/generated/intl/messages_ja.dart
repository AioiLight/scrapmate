// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja';

  static m0(projectName) => "${projectName} を追加しました";

  static m1(projectName) => "${projectName} を削除しました";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add" : MessageLookupByLibrary.simpleMessage("追加"),
    "add_project" : MessageLookupByLibrary.simpleMessage("プロジェクトの追加"),
    "add_project_desc" : MessageLookupByLibrary.simpleMessage("Scrapbox のプロジェクト URL を入力してプロジェクトを追加"),
    "add_project_placeholder" : MessageLookupByLibrary.simpleMessage("プロジェクト URL (例: help, shokai)"),
    "cancel" : MessageLookupByLibrary.simpleMessage("キャンセル"),
    "delete" : MessageLookupByLibrary.simpleMessage("削除"),
    "no" : MessageLookupByLibrary.simpleMessage("いいえ"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "open_in_browser" : MessageLookupByLibrary.simpleMessage("ブラウザで開く"),
    "project_added" : m0,
    "project_removed" : m1,
    "settings" : MessageLookupByLibrary.simpleMessage("設定"),
    "settings_black_theme" : MessageLookupByLibrary.simpleMessage("ブラックテーマ"),
    "settings_black_theme_desc" : MessageLookupByLibrary.simpleMessage("ダークテーマを使用するときは真っ黒の背景色を使用する"),
    "settings_grid" : MessageLookupByLibrary.simpleMessage("グリッドの列数"),
    "settings_grid_desc" : MessageLookupByLibrary.simpleMessage("プロジェクトページのグリッドの列数"),
    "settings_looks" : MessageLookupByLibrary.simpleMessage("見た目"),
    "settings_scrapbox" : MessageLookupByLibrary.simpleMessage("Scrapbox"),
    "settings_telomere" : MessageLookupByLibrary.simpleMessage("テロメア"),
    "settings_telomere_desc" : MessageLookupByLibrary.simpleMessage("段落の横にテロメアを表示する"),
    "settings_theme" : MessageLookupByLibrary.simpleMessage("テーマ"),
    "settings_theme_dark" : MessageLookupByLibrary.simpleMessage("ダーク"),
    "settings_theme_default" : MessageLookupByLibrary.simpleMessage("システムに従う"),
    "settings_theme_desc" : MessageLookupByLibrary.simpleMessage("ScrapMate のテーマ"),
    "settings_theme_light" : MessageLookupByLibrary.simpleMessage("ライト"),
    "share" : MessageLookupByLibrary.simpleMessage("共有"),
    "yes" : MessageLookupByLibrary.simpleMessage("はい")
  };
}
