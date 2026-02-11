import 'package:flutter/material.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class PhotographerDetailCard extends StatelessWidget {
  final String title;
  final String photographer;

  const PhotographerDetailCard({
    super.key,
    required this.title,
    required this.photographer,
  });

  @override
  Widget build(BuildContext context) {
    var lng = AppLocalizations.of(context);
    return Center(
      child: SafeArea(
        top: false,
        bottom: false,
        minimum: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${lng?.title ?? ''}:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsetsGeometry.only(left: 10),
                child: Text(title, style: const TextStyle()),
              ),
              const Divider(),
              Text(
                '${lng?.photographer ?? ''}:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsetsGeometry.only(left: 10),
                child: Text(
                  photographer,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 91, 91, 91),
                  ),
                ),
              ),
              const Divider(),
              Text(
                '${lng?.overview ?? ''}:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
