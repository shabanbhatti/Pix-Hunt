import 'package:flutter/material.dart';
import 'package:pix_hunt_project/Pages/View%20home%20cetagory%20Page/view_page.dart';

class BoxWidget extends StatelessWidget {
  const BoxWidget({super.key, required this.record});

  final ({String title, String imgPath}) record;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              ViewContentPage.pageName,
              arguments:
                  {'record': record, 'title': ''} as Map<String, dynamic>,
            );
          },
          child: Container(
            height: 130,
            width: 230,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage('assets/images/${record.imgPath}'),
                fit: BoxFit.cover,
                opacity: 0.8,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  record.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
