import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

void showLogoutDialog(BuildContext context, OnPressed logoutButton) {
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
