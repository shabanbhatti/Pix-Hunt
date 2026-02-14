import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/Utils/extensions.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class BottomThanksWidget extends StatelessWidget {
  const BottomThanksWidget({super.key, required this.value});
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '🎉${AppLocalizations.of(context)!.thanks} ',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          value.firstTwoWords(),
          style: const TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Text(
          ' ${AppLocalizations.of(context)!.forVisiting}🎉',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
