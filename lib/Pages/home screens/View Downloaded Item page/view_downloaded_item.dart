import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20controller/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/downloads_image_model.dart';
import 'package:pix_hunt_project/core/Utils/date_format_util.dart';
import 'package:pix_hunt_project/core/Utils/dialog%20boxes/delete_dialog_boxes.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ViewDownloadedItem extends StatefulWidget {
  const ViewDownloadedItem({super.key, required this.downloadImageModel});
  static const pageName = '/view_downloaded_item';
  final DownloadsImageModel downloadImageModel;

  @override
  State<ViewDownloadedItem> createState() => _ViewDownloadedItemState();
}

class _ViewDownloadedItemState extends State<ViewDownloadedItem>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lng = AppLocalizations.of(context);
    log('View Downloaded items page build called');
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,

              leading: Padding(
                padding: EdgeInsetsGeometry.all(5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: ConstantColors.appColor.withAlpha(150),
                    radius: 5,
                    child: const Icon(
                      CupertinoIcons.back,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsetsGeometry.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer(
                        builder: (context, ref, _) {
                          return GestureDetector(
                            onTap: () {
                              deleteDialogBox(
                                context,
                                describtion: lng?.doYouWantToDelete ?? '',
                                title: lng?.delete ?? '',
                                delete: () {
                                  ref
                                      .read(userDbProvider.notifier)
                                      .deleteDownloadedHistory(
                                        widget.downloadImageModel,
                                      );
                                  Navigator.pop(context);
                                },
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: ConstantColors.appColor
                                  .withAlpha(150),
                              radius: 23,
                              child: const Icon(
                                CupertinoIcons.delete,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
              pinned: true,
              expandedHeight: 500,
              floating: true,
              snap: true,
              flexibleSpace: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: const BoxDecoration(color: Colors.black),
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.downloadImageModel.imgUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ],
                ),
              ),
            ),

            SliverSafeArea(
              top: false,
              sliver: SliverPadding(
                padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _listtile(
                        title: lng?.imageTitle ?? '',
                        value: widget.downloadImageModel.title,
                      ),
                      const Divider(),
                      _listtile(
                        title: lng?.pixels ?? '',
                        value: widget.downloadImageModel.pixels,
                      ),
                      const Divider(),
                      _listtile(
                        title: lng?.date ?? '',
                        value: DateFormatUtil.dateFormat(
                          widget.downloadImageModel.date,
                        ),
                      ),
                      const Divider(),
                      _listtile(
                        title: lng?.url ?? '',
                        value: widget.downloadImageModel.imgUrl,
                      ),
                      const Divider(),
                      _listtile(
                        title: lng?.status ?? '',
                        value: 'Saved to gallery',
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _listtile({required String title, required String value}) {
  return Row(
    children: [
      Text('$title:', style: TextStyle(fontWeight: FontWeight.bold)),
      Expanded(
        child: Padding(
          padding: EdgeInsetsGeometry.only(left: 10, right: 10),
          child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    ],
  );
}
