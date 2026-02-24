import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

void showUserImageOptionsSheet(
  BuildContext context, {
  required OnPressed open,
  required OnPressed changePic,
  required OnPressed remove,
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
              backgroundColor: ConstantColors.appColor,
              child: Icon(Icons.image, color: Colors.white),
            ),
            title: Text(lng?.openImage ?? ''),
            onTap: open,
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: ConstantColors.appColor,
              child: Icon(Icons.edit, color: Colors.white),
            ),
            title: Text(lng?.changePicture ?? ''),
            onTap: changePic,
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: ConstantColors.appColor,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            title: Text(lng?.remove ?? '', style: TextStyle(color: Colors.red)),
            onTap: remove,
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
