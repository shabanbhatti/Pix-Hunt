import 'package:flutter/cupertino.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class LoginTitleWidget extends StatelessWidget {
  const LoginTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var lng = AppLocalizations.of(context);
    return Text(
      lng?.loginYourAccount ?? '',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
    );
  }
}
