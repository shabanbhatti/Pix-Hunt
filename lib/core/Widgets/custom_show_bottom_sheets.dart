import 'package:flutter/material.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

void customBottomSheet(
  BuildContext context, {
  required void Function() open,
  required void Function() delete,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (contextz) {
      var lng = AppLocalizations.of(contextz);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: Text(lng?.open ?? ''),
              onTap: open,
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(
                lng?.delete ?? '',
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                delete();
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text(lng?.cancel ?? ''),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
