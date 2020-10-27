// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Add project`
  String get add_project {
    return Intl.message(
      'Add project',
      name: 'add_project',
      desc: '',
      args: [],
    );
  }

  /// `Enter Scrapbox's project URL to add project`
  String get add_project_desc {
    return Intl.message(
      'Enter Scrapbox\'s project URL to add project',
      name: 'add_project_desc',
      desc: '',
      args: [],
    );
  }

  /// `Project URL (e.g. help, shokai)`
  String get add_project_placeholder {
    return Intl.message(
      'Project URL (e.g. help, shokai)',
      name: 'add_project_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Open in browser`
  String get open_in_browser {
    return Intl.message(
      'Open in browser',
      name: 'open_in_browser',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Looks`
  String get settings_looks {
    return Intl.message(
      'Looks',
      name: 'settings_looks',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get settings_theme {
    return Intl.message(
      'Theme',
      name: 'settings_theme',
      desc: '',
      args: [],
    );
  }

  /// `ScrapMate's theme`
  String get settings_theme_desc {
    return Intl.message(
      'ScrapMate\'s theme',
      name: 'settings_theme_desc',
      desc: '',
      args: [],
    );
  }

  /// `Follow system`
  String get settings_theme_default {
    return Intl.message(
      'Follow system',
      name: 'settings_theme_default',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get settings_theme_light {
    return Intl.message(
      'Light',
      name: 'settings_theme_light',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get settings_theme_dark {
    return Intl.message(
      'Dark',
      name: 'settings_theme_dark',
      desc: '',
      args: [],
    );
  }

  /// `Black theme`
  String get settings_black_theme {
    return Intl.message(
      'Black theme',
      name: 'settings_black_theme',
      desc: '',
      args: [],
    );
  }

  /// `Use pure black background color when using dark theme`
  String get settings_black_theme_desc {
    return Intl.message(
      'Use pure black background color when using dark theme',
      name: 'settings_black_theme_desc',
      desc: '',
      args: [],
    );
  }

  /// `Scrapbox`
  String get settings_scrapbox {
    return Intl.message(
      'Scrapbox',
      name: 'settings_scrapbox',
      desc: '',
      args: [],
    );
  }

  /// `Number of grid columns`
  String get settings_grid {
    return Intl.message(
      'Number of grid columns',
      name: 'settings_grid',
      desc: '',
      args: [],
    );
  }

  /// `Number of grid columns in project page`
  String get settings_grid_desc {
    return Intl.message(
      'Number of grid columns in project page',
      name: 'settings_grid_desc',
      desc: '',
      args: [],
    );
  }

  /// `Telomere`
  String get settings_telomere {
    return Intl.message(
      'Telomere',
      name: 'settings_telomere',
      desc: '',
      args: [],
    );
  }

  /// `Show a telomere beside the paragraph`
  String get settings_telomere_desc {
    return Intl.message(
      'Show a telomere beside the paragraph',
      name: 'settings_telomere_desc',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}