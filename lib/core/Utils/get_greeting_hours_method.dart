import 'package:flutter/widgets.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

String getGreetingMessage(BuildContext context) {
  var lng = AppLocalizations.of(context);
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return lng?.goodMorning ?? '';
  } else if (hour >= 12 && hour < 17) {
    return lng?.goodAfternoon ?? '';
  } else if (hour >= 17 && hour < 21) {
    return lng?.goodEvening ?? '';
  } else {
    return lng?.goodNight ?? '';
  }
}
