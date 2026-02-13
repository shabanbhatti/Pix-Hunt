import 'package:flutter/material.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class PhotographerDetailCard extends StatelessWidget {
  final String title;
  final String photographer;
  final Animation<double> scaleTitle;
  final Animation<double> fadeTitle;
  final Animation<double> scalePhotographer;
  final Animation<double> fadePhotographer;
  final Animation<double> scaleOverview;
  final Animation<double> fadeOverview;
  const PhotographerDetailCard({
    super.key,
    required this.title,
    required this.photographer,
    required this.scaleTitle,
    required this.fadeTitle,
    required this.scalePhotographer,
    required this.fadePhotographer,
    required this.scaleOverview,
    required this.fadeOverview,
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
              ScaleTransition(
                scale: scaleTitle,
                child: FadeTransition(
                  opacity: fadeTitle,
                  child: Text(
                    '${lng?.title ?? ''}:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsGeometry.only(left: 10),
                child: ScaleTransition(
                  scale: scaleTitle,
                  child: FadeTransition(
                    opacity: fadeTitle,
                    child: Text(title, style: const TextStyle()),
                  ),
                ),
              ),
              const Divider(),
              ScaleTransition(
                scale: scalePhotographer,
                child: FadeTransition(
                  opacity: fadePhotographer,
                  child: Text(
                    '${lng?.photographer ?? ''}:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsGeometry.only(left: 10),
                child: ScaleTransition(
                  scale: scalePhotographer,
                  child: FadeTransition(
                    opacity: fadePhotographer,
                    child: Text(
                      photographer,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 91, 91, 91),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
              ScaleTransition(
                scale: scaleOverview,
                child: FadeTransition(
                  opacity: fadeOverview,
                  child: Text(
                    '${lng?.overview ?? ''}:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
