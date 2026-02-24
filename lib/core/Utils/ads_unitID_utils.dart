import 'dart:io';

abstract class AdsUnitIdUtils {
  static String get bannerAddUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2558915820027702/3763500359';
    } else if (Platform.isIOS) {
      return "ca-app-pub-2558915820027702/5268153717";
    } else {
      throw Exception('Unsupported platform');
    }
  }

  static String get interstitialAddUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2558915820027702/9775468845';
    } else if (Platform.isIOS) {
      return "ca-app-pub-2558915820027702/9559846421";
    } else {
      throw Exception('Unsupported platform');
    }
  }
}
