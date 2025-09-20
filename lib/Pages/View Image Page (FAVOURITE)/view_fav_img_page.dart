import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pix_hunt_project/Models/fav_items.dart';

class ViewFavImagePage extends StatefulWidget {
  const ViewFavImagePage({
    super.key,
    required this.favItemModalClass,
    required this.index,
  });
  static const pageName = '/view_fav_image';
  final FavItemModalClass favItemModalClass;
  final int index;
  @override
  State<ViewFavImagePage> createState() => _ViewImagePageState();
}

class _ViewImagePageState extends State<ViewFavImagePage> {
  late List<String> list;

  @override
  void initState() {
    super.initState();
    print(widget.index);

    list = [
      widget.favItemModalClass.originalPhotoUrl,
      widget.favItemModalClass.largePhotoUrl,
      widget.favItemModalClass.mediumPhotoUrl,
      widget.favItemModalClass.smallPhotoUrl,
    ];

    pageController = PageController(initialPage: widget.index);
  }

  late PageController pageController;

  @override
  Widget build(BuildContext context) {
    print('View Image Build called');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: PageView.builder(
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return InteractiveViewer(
              maxScale: 4.0,
              minScale: 0.5,
              child: CachedNetworkImage(
                imageUrl: list[index],
                fit: BoxFit.contain,
                fadeInDuration: const Duration(milliseconds: 300),
                placeholder:
                    (context, url) =>
                        Center(child: const CupertinoActivityIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: 200,
              ),
            );
          },
        ),
      ),
    );
  }
}
