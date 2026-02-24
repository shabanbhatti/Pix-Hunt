import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/core/constants/constants_sharedPref_keys.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/core/services/shared_preference_service.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier(sharedPreferencesService: getIt<SharedPreferencesService>());
});

class LanguageNotifier extends StateNotifier<String> {
  final SharedPreferencesService sharedPreferencesService;
  LanguageNotifier({required this.sharedPreferencesService}) : super('en');

  Future<void> getLanguage() async {
    var language = await sharedPreferencesService.getString(ConstantsSharedprefKeys.languageKey) ?? '';
    if (language.isNotEmpty) {
      state = language;
    }
  }

  void languageToggled(String localeCode) async {
    state = localeCode;
    await sharedPreferencesService.setString(ConstantsSharedprefKeys.languageKey, localeCode);
  }
}
