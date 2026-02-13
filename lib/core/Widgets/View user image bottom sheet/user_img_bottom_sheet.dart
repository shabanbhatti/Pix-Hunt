import 'package:flutter/material.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

void showUserImageOptionsSheet(
  BuildContext context, {
  required void Function() open,
  required void Function() changePic,
  required void Function() remove,
}) {
  showModalBottomSheet(
    showDragHandle: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),

    builder: (context) {
      var lng = AppLocalizations.of(context);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Icon(Icons.image, color: Colors.white),
            ),
            title: Text(lng?.openImage ?? ''),
            onTap: open,
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Icon(Icons.edit, color: Colors.white),
            ),
            title: Text(lng?.changePicture ?? ''),
            onTap: changePic,
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            title: Text(lng?.remove ?? '', style: TextStyle(color: Colors.red)),
            onTap: remove,
          ),
          const Divider(),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Icon(Icons.close, color: Colors.white),
            ),
            title: Text(lng?.cancel ?? ''),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
