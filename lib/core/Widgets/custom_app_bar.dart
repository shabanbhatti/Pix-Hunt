import 'package:flutter/material.dart';
import 'package:pix_hunt_project/main.dart';

PreferredSizeWidget customAppBar(String title, {void Function()? onTap}) {
  return AppBar(
    backgroundColor: Colors.indigo,
    leading: IconButton(
      onPressed:
          onTap ??
          () {
            Navigator.pop(navigatorKey.currentContext!);
          },
      icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
    ),
    title: Text(title, style: const TextStyle(color: Colors.white)),
  );
}
