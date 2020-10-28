// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m0(projectName) => "Added ${projectName}";

  static m1(projectName) => "Removed ${projectName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add" : MessageLookupByLibrary.simpleMessage("Add"),
    "add_project" : MessageLookupByLibrary.simpleMessage("Add project"),
    "add_project_desc" : MessageLookupByLibrary.simpleMessage("Enter Scrapbox\'s project URL to add project"),
    "add_project_placeholder" : MessageLookupByLibrary.simpleMessage("Project URL (e.g. help, shokai)"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "delete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "no" : MessageLookupByLibrary.simpleMessage("No"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "open_in_browser" : MessageLookupByLibrary.simpleMessage("Open in browser"),
    "project_added" : m0,
    "project_removed" : m1,
    "settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "settings_black_theme" : MessageLookupByLibrary.simpleMessage("Black theme"),
    "settings_black_theme_desc" : MessageLookupByLibrary.simpleMessage("Use pure black background color when using dark theme"),
    "settings_grid" : MessageLookupByLibrary.simpleMessage("Number of grid columns"),
    "settings_grid_desc" : MessageLookupByLibrary.simpleMessage("Number of grid columns in project page"),
    "settings_looks" : MessageLookupByLibrary.simpleMessage("Looks"),
    "settings_scrapbox" : MessageLookupByLibrary.simpleMessage("Scrapbox"),
    "settings_telomere" : MessageLookupByLibrary.simpleMessage("Telomere"),
    "settings_telomere_desc" : MessageLookupByLibrary.simpleMessage("Show a telomere beside the paragraph"),
    "settings_theme" : MessageLookupByLibrary.simpleMessage("Theme"),
    "settings_theme_dark" : MessageLookupByLibrary.simpleMessage("Dark"),
    "settings_theme_default" : MessageLookupByLibrary.simpleMessage("Follow system"),
    "settings_theme_desc" : MessageLookupByLibrary.simpleMessage("ScrapMate\'s theme"),
    "settings_theme_light" : MessageLookupByLibrary.simpleMessage("Light"),
    "share" : MessageLookupByLibrary.simpleMessage("Share"),
    "yes" : MessageLookupByLibrary.simpleMessage("Yes")
  };
}
