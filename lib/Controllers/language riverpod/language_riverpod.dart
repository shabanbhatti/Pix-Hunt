import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/services/shared_preference_service.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en');

  Future<void> getLanguage() async {
    var language = await SpService.getString('language') ?? '';
    if (language.isNotEmpty) {
      state = language;
    }
  }

  void languageToggled(String localeCode) async {
    state = localeCode;
    await SpService.setString('language', localeCode);
  }
}
