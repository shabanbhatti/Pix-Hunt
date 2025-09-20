import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewUserImgPage extends StatelessWidget {
  const ViewUserImgPage({
    super.key,
    required this.imgPath,
    required this.imgUrl,
  });

  final String imgPath;
  final String imgUrl;
  static const pageName = '/view_user_img';

  @override
  Widget build(BuildContext context) {
    print('VIEW USER IMG BUILD CALLED');
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5.0,
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Hero(
                tag: 'user_image',
                child: ClipOval(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    color: Colors.white,
                    width: 300,
                    height: 300,
                    child:
                        (imgPath == '')
                            ? CachedNetworkImage(
                              imageUrl: imgUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => _loading(),
                            )
                            : Image.file(File(imgPath), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _loading() {
  return Center(
    child: ClipOval(
      child: Skeletonizer(
        enabled: true,
        child: Container(color: Colors.grey[300], height: 150, width: 150),
      ),
    ),
  );
}
