import 'package:flutter/material.dart';

var darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.white,
  drawerTheme: DrawerThemeData(backgroundColor: Colors.black),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: const Color.fromARGB(255, 29, 29, 29)),
  cardColor:const Color.fromARGB(255, 29, 29, 29),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Colors.white.withAlpha(70),
    selectionHandleColor: Colors.white,
  ),
  dividerColor: Colors.white,

);

var lightheme = ThemeData(
  dividerColor: Colors.black,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.black,
  drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
  cardColor: Colors.white,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.black,
    selectionColor: Colors.black.withAlpha(70),
    selectionHandleColor: Colors.black
  )
);
