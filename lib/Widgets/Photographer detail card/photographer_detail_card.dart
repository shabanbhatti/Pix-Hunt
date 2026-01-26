import 'package:flutter/material.dart';

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
              const Text(
                'Title:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsetsGeometry.only(left: 10),
                child: Text(title, style: const TextStyle()),
              ),
              const Divider(),
              const Text(
                'Photographer:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              const Text(
                'Overview:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
