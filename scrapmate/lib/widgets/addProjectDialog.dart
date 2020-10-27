import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddProjectDialog {
  String url = "";

  void _textChanged(String e) {
    url = e;
  }

  AlertDialog showDialog(BuildContext buildContext) {
    return AlertDialog(
        title: Text(AppLocalizations.of(buildContext).add_project),
        content: Column(
          children: [
            Text(AppLocalizations.of(buildContext).add_project_desc),
            const Text("https://scrapbox.io/"),
            TextField(
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(buildContext)
                      .add_project_placeholder),
              onChanged: _textChanged,
              autofocus: true,
            )
          ],
        ),
        actions: [
          SimpleDialogOption(
              onPressed: () => Navigator.pop(buildContext, null),
              child: Text(AppLocalizations.of(buildContext).cancel)),
          SimpleDialogOption(
              onPressed: () => Navigator.pop(buildContext, url),
              child: Text(AppLocalizations.of(buildContext).add)),
        ]);
  }
}
