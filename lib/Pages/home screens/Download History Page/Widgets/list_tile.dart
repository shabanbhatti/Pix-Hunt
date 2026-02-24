import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomListTile1 extends StatelessWidget {
  const CustomListTile1({
    super.key,
    required this.imgUrl,
    required this.onTap,
    required this.title,
    required this.photographer,
    required this.date,
    required this.onLongTap,
  });
  final String imgUrl;
  final String title;
  final String photographer;
  final OnPressed onTap;
  final OnPressed onLongTap;
  final String date;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const Border(bottom: BorderSide(width: 0.2)),
      leading: Container(
        width: 80,
        height: 80,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(100),
          borderRadius: BorderRadius.circular(10),
        ),
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          fit: BoxFit.cover,
          placeholder:
              (context, url) => Skeletonizer(
                enabled: true,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
              ),
          errorWidget:
              (context, url, error) =>
                  const Icon(Icons.wifi_off, color: Colors.red),
        ),
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(photographer),
      trailing: Text(date),
      onLongPress: onLongTap,
      onTap: onTap,
    );
  }
}
