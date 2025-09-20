import 'package:flutter/material.dart';

void showLogoutDialog(BuildContext context, void Function() logoutButton) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Logout'),
          content: const Text('Wanna Logout?'),
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
        (context) => AlertDialog(
          title: Image.asset(
            'assets/images/delete.png',
            height: 50,
            width: 50,
            fit: BoxFit.fitHeight,
          ),
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Wanna delete?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: delete,
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
  );
}
