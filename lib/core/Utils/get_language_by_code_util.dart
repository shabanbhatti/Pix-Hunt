String getFlagFromCode(String code) {
  switch (code) {
    case 'en':
      return '🇺🇸 English (US)';
    case 'ur':
      return '🇵🇰 اردو';
    case 'en_GB':
      return '🇬🇧 English (UK)';
    case 'ar':
      return '🇸🇦 العربية';
    case 'es':
      return '🇪🇸 Español';
    case 'zh':
      return '🇨🇳 中文';
    case 'fr':
      return '🇫🇷 Français';
    case 'de':
      return '🇩🇪 Deutsch';
    case 'tr':
      return '🇹🇷 Türkçe';
    case 'ru':
      return '🇷🇺 Русский';
    case 'pt':
      return '🇵🇹 Português';
    case 'bn':
      return '🇧🇩 বাংলা';
    case 'ja':
      return '🇯🇵 日本語';
    case 'ko':
      return '🇰🇷 한국어';
    case 'it':
      return '🇮🇹 Italiano';
    default:
      return '🇺🇸 English (US)';
  }
}
