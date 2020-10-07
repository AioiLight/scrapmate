import 'package:flutter/material.dart';

class AddProjectDialog {
  String url = "";

  void _textChanged(String e) {
    url = e;
  }

  AlertDialog showDialog(BuildContext buildContext) {
    return AlertDialog(
        title: Text("Add project"),
        content: Column(
          children: [
            const Text("Enter Scrapbox's project URL to add project"),
            const Text("https://scrapbox.io/"),
            TextField(
              maxLines: 1,
              decoration: const InputDecoration(hintText: "Project URL"),
              onChanged: _textChanged,
              autofocus: true,
            )
          ],
        ),
        actions: [
          SimpleDialogOption(
              onPressed: () => Navigator.pop(buildContext, null),
              child: Text("Cancel")),
          SimpleDialogOption(
              onPressed: () => Navigator.pop(buildContext, url),
              child: Text("Add")),
        ]);
  }
}
