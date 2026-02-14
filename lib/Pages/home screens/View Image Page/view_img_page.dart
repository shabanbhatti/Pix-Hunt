import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewImagePage extends StatefulWidget {
  const ViewImagePage({super.key, required this.imgRecord});
  static const pageName = '/view_fav_image';
  final ({String imgPath, String pixels}) imgRecord;

  @override
  State<ViewImagePage> createState() => _ViewImagePageState();
}

class _ViewImagePageState extends State<ViewImagePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.bounceOut),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('View image page build called');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: GestureDetector(
          child: Icon(CupertinoIcons.back, size: 30),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.imgRecord.pixels),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                children: [
                  ScaleTransition(
                    scale: scale,
                    child: InteractiveViewer(
                      maxScale: 4.0,
                      minScale: 0.5,
                      child: CachedNetworkImage(
                        imageUrl: widget.imgRecord.imgPath,
                        placeholder:
                            (context, url) => Center(
                              child: const CupertinoActivityIndicator(),
                            ),
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
