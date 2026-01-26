import 'package:flutter/material.dart';

void showLogoutDialog(BuildContext context, void Function() logoutButton) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Do you want to log out your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: logoutButton,
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
  );
}

void removeFavoritesItemsDialog(BuildContext context, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text('Remove from Favourites'),
          content: Text(
            'By unfavouriting, this item will be removed from your favourites list.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
              },
              child: Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
  );
}

void deleteDialogBox(BuildContext context, void Function() delete) {
  showDialog(
    context: context,
    builder:
        (context) => SafeArea(
          bottom: true,
          child: AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.red, size: 40),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10),
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Do you want to delete?',
              style: TextStyle(fontSize: 12),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
              Padding(
                padding: const EdgeInsetsGeometry.only(left: 20),
                child: GestureDetector(
                  onTap: () {
                    delete();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
  );
}
