import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/core/Theme/app_theme.dart';
import 'package:pix_hunt_project/core/constants/constants_sharedPref_keys.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/core/services/shared_preference_service.dart';

final themeProvider = StateNotifierProvider<ThemeStateNotifier, ThemeClass>((
  ref,
) {
  return ThemeStateNotifier(
    sharedPreferencesService: getIt<SharedPreferencesService>(),
  );
});

class ThemeStateNotifier extends StateNotifier<ThemeClass> {
  final SharedPreferencesService sharedPreferencesService;
  ThemeStateNotifier({required this.sharedPreferencesService})
    : super(ThemeClass(isDark: false, themeData: lightheme));

  Future<void> getTheme() async {
    var myTheme =
        await sharedPreferencesService.getStringForTheme(
          ConstantsSharedprefKeys.themeKey,
        ) ??
        'light';

    if (myTheme == 'light') {
      state = state.copyWith(isDarkX: false, themeDataX: lightheme);
    } else {
      state = state.copyWith(isDarkX: true, themeDataX: darkMode);
    }
  }

  Future<void> toggeled() async {
    if (state.themeData == lightheme) {
      state = state.copyWith(isDarkX: true, themeDataX: darkMode);

      sharedPreferencesService.setString(
        ConstantsSharedprefKeys.themeKey,
        'dark',
      );
    } else {
      state = state.copyWith(isDarkX: false, themeDataX: lightheme);
      sharedPreferencesService.setString(
        ConstantsSharedprefKeys.themeKey,
        'light',
      );
    }
  }
}

class ThemeClass {
  final ThemeData themeData;

  final bool isDark;

  const ThemeClass({required this.isDark, required this.themeData});

  ThemeClass copyWith({bool? isDarkX, ThemeData? themeDataX}) {
    return ThemeClass(
      isDark: isDarkX ?? this.isDark,
      themeData: themeDataX ?? this.themeData,
    );
  }
}
