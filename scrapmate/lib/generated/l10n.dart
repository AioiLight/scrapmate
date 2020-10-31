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

  /// `(e.g. help, shokai)`
  String get add_project_placeholder {
    return Intl.message(
      '(e.g. help, shokai)',
      name: 'add_project_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Added {projectName}`
  String project_added(Object projectName) {
    return Intl.message(
      'Added $projectName',
      name: 'project_added',
      desc: '',
      args: [projectName],
    );
  }

  /// `Removed {projectName}`
  String project_removed(Object projectName) {
    return Intl.message(
      'Removed $projectName',
      name: 'project_removed',
      desc: '',
      args: [projectName],
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

  /// `Unable to open browser`
  String get open_in_browser_failed {
    return Intl.message(
      'Unable to open browser',
      name: 'open_in_browser_failed',
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

  /// `Unable to connect Scrabox. Check your network connection.`
  String get scrap_network_error {
    return Intl.message(
      'Unable to connect Scrabox. Check your network connection.',
      name: 'scrap_network_error',
      desc: '',
      args: [],
    );
  }

  /// `Scrapbox project not found`
  String get scrap_404 {
    return Intl.message(
      'Scrapbox project not found',
      name: 'scrap_404',
      desc: '',
      args: [],
    );
  }

  /// `Unable to access Scrapbox project because you are not a member`
  String get scrap_403 {
    return Intl.message(
      'Unable to access Scrapbox project because you are not a member',
      name: 'scrap_403',
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

  /// `Loading images`
  String get settings_loading_images {
    return Intl.message(
      'Loading images',
      name: 'settings_loading_images',
      desc: '',
      args: [],
    );
  }

  /// `Reduce mobile data without loading images`
  String get settings_loading_images_desc {
    return Intl.message(
      'Reduce mobile data without loading images',
      name: 'settings_loading_images_desc',
      desc: '',
      args: [],
    );
  }

  /// `Always`
  String get settings_loading_images_always {
    return Intl.message(
      'Always',
      name: 'settings_loading_images_always',
      desc: '',
      args: [],
    );
  }

  /// `Wi-Fi only`
  String get settings_loading_images_wifi {
    return Intl.message(
      'Wi-Fi only',
      name: 'settings_loading_images_wifi',
      desc: '',
      args: [],
    );
  }

  /// `Never`
  String get settings_loading_images_never {
    return Intl.message(
      'Never',
      name: 'settings_loading_images_never',
      desc: '',
      args: [],
    );
  }

  /// `Delete cache`
  String get settings_delete_cache {
    return Intl.message(
      'Delete cache',
      name: 'settings_delete_cache',
      desc: '',
      args: [],
    );
  }

  /// `Delete ScrapMate's cache in Android settings`
  String get settings_delete_cache_desc {
    return Intl.message(
      'Delete ScrapMate\'s cache in Android settings',
      name: 'settings_delete_cache_desc',
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

  /// `ScrapMate`
  String get settings_scrapmate {
    return Intl.message(
      'ScrapMate',
      name: 'settings_scrapmate',
      desc: '',
      args: [],
    );
  }

  /// `About ScrapMate`
  String get settings_scrapmate_about {
    return Intl.message(
      'About ScrapMate',
      name: 'settings_scrapmate_about',
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