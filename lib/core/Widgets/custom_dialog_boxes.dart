import 'package:flutter/material.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

void showLogoutDialog(BuildContext context, void Function() logoutButton) {
  showDialog(
    context: context,
    builder: (contextz) {
      var lng = AppLocalizations.of(contextz);
      return AlertDialog(
        title: Text(
          lng?.logout ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(lng?.doYouWantToLogout ?? ''),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(lng?.no ?? ''),
          ),
          TextButton(
            onPressed: logoutButton,
            child: Text(
              lng?.logout ?? '',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

void removeFavoritesItemsDialog(BuildContext context, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (contextz) {
      var lng = AppLocalizations.of(contextz);
      return AlertDialog(
        title: Text(lng?.removeFromFavourite ?? ''),
        content: Text(lng?.unfavouritingMessage ?? ''),
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

void deleteDialogBox(BuildContext context, void Function() delete) {
  showDialog(
    context: context,
    builder: (contextz) {
      var lng = AppLocalizations.of(contextz);
      return SafeArea(
        bottom: true,
        child: AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 40),
              Padding(
                padding: const EdgeInsetsGeometry.only(left: 10),
                child: Text(
                  lng?.delete ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Text(
            lng?.doYouWantToDelete ?? '',
            style: const TextStyle(fontSize: 12),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(lng?.no ?? ''),
            ),
            Padding(
              padding: const EdgeInsetsGeometry.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  delete();
                  Navigator.pop(context);
                },
                child: Text(
                  lng?.delete ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
