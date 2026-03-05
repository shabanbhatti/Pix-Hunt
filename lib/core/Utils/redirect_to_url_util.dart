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

  static Future<void> openWhatsApp() async {
    const phoneNumber = "923281022320";
    const message = "Hello Shaban, I want to hire you";

    final Uri url = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('ERROR FOUND');
    }
  }
}
