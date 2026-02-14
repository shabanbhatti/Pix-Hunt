import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/dowloads_items_model.dart';
import 'package:pix_hunt_project/core/Utils/date_format_util.dart';
import 'package:pix_hunt_project/core/Widgets/custom_dialog_boxes.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ViewDownloadedItem extends StatefulWidget {
  const ViewDownloadedItem({super.key, required this.downloadsItem});
  static const pageName = '/view_downloaded_item';
  final DownloadsItem downloadsItem;

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
                    backgroundColor: Colors.indigo.withAlpha(150),
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
                              deleteDialogBox(context, () {
                                ref
                                    .read(userDbProvider.notifier)
                                    .deleteDownloadedHistory(
                                      widget.downloadsItem,
                                    );

                                Navigator.pop(context);
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.indigo.withAlpha(150),
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
                      imageUrl: widget.downloadsItem.imgUrl,
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
                        value: widget.downloadsItem.title,
                      ),
                      const Divider(),
                      _listtile(
                        title: lng?.pixels ?? '',
                        value: widget.downloadsItem.pixels,
                      ),
                      const Divider(),
                      _listtile(
                        title: lng?.date ?? '',
                        value: DateFormatUtil.dateFormat(
                          widget.downloadsItem.date,
                        ),
                      ),
                      const Divider(),
                      _listtile(
                        title: lng?.url ?? '',
                        value: widget.downloadsItem.imgUrl,
                      ),
                      const Divider(),
                      _listtile(
                        title: lng?.status ?? '',
                        value: 'Save to gallery',
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
