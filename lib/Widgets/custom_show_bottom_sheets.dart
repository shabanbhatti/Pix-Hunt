import 'package:flutter/material.dart';

void customBottomSheet(
  BuildContext context, {
  required void Function() open,
  required void Function() delete,
}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.open_in_new),
              title: Text('Open'),
              onTap: open,
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                delete();
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
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
