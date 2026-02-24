import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

void deleteDialogBox(BuildContext context, OnPressed delete) {
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
