import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

void removeBookmarkItemDialog(BuildContext context, OnPressed onDelete) {
  showDialog(
    context: context,
    builder: (contextz) {
      var lng = AppLocalizations.of(contextz);
      return AlertDialog(
        title: Text(lng?.removeFromBookmark ?? ''),
        content: Text(lng?.unbookmarkingMessage ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(lng?.cancel ?? ''),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.of(context).pop();
            },
            child: Text(
              lng?.remove ?? '',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
