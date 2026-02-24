import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

void showOptionsSheet(
  BuildContext context, {
  required OnPressed open,
  required OnPressed delete,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (contextz) {
      var lng = AppLocalizations.of(contextz);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: ConstantColors.appColor,
              child: const Icon(Icons.open_in_new, color: Colors.white),
            ),
            title: Text(lng?.open ?? ''),
            onTap: open,
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: ConstantColors.appColor,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            title: Text(
              lng?.delete ?? '',
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              delete();
            },
          ),
          const Divider(),
          SafeArea(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: ConstantColors.appColor,
                child: Icon(Icons.close, color: Colors.white),
              ),
              title: Text(lng?.cancel ?? ''),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      );
    },
  );
}
