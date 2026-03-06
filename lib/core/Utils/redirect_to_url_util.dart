import 'package:url_launcher/url_launcher.dart';

abstract class RedirectToUrlUtil {
  static Future<void> openThisLink(String typeUrl) async {
    if (typeUrl.isNotEmpty) {
      final Uri url = Uri.parse(typeUrl);

      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    }
  }
}
