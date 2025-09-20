import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeStateNotifier, ThemeClass>((ref) {
  return ThemeStateNotifier();
});

class ThemeStateNotifier extends StateNotifier<ThemeClass> {
  ThemeStateNotifier(): super(ThemeClass(isDark: false, themeData: lightheme));
  

Future<void> getTheme()async{

var sp = await SharedPreferences.getInstance();

var myTheme= sp.getString('theme')??'light';

if (myTheme=='light') {
  state=state.copyWith(isDarkX: false, themeDataX: lightheme);
  
}else{
  state=state.copyWith(isDarkX: true, themeDataX: darkMode);
  
}

}


Future<void> toggeled()async{
var sp = await SharedPreferences.getInstance();

if (state.themeData==lightheme) {
  state=state.copyWith(isDarkX: true, themeDataX: darkMode);

  sp.setString('theme', 'dark');
  
}else{
  state=state.copyWith(isDarkX: false, themeDataX: lightheme);
  sp.setString('theme', 'light');
  
}


}


}

class ThemeClass {
  
final ThemeData themeData;

final bool isDark;


const ThemeClass({required this.isDark, required this.themeData});

ThemeClass copyWith({ bool? isDarkX, ThemeData? themeDataX }){
  return ThemeClass(isDark: isDarkX?? this.isDark, themeData: themeDataX?? this.themeData );
}

}