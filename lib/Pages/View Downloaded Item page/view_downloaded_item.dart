import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/dowloads_items_model.dart';
import 'package:pix_hunt_project/Widgets/custom_dialog_boxes.dart';

class ViewDownloadedItem extends StatelessWidget {
  const ViewDownloadedItem({super.key, required this.downloadsItem});
  static const pageName = '/view_downloaded_item';
  final DownloadsItem downloadsItem;

  @override
  Widget build(BuildContext context) {
    print('Downloaded Item BUILD CALLED');
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              backgroundColor: Colors.indigo,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Consumer(
                    builder: (context, ref, child) {
                      return PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                          size: 40,
                        ),
                        onSelected: (value) {
                          if (value == 'delete') {
                            deleteDialogBox(context, () {
                              ref
                                  .read(userDbProvider.notifier)
                                  .deleteDownloadedHistory(downloadsItem);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          }
                        },
                        itemBuilder:
                            (context) => [
                              PopupMenuItem(
                                value: 'delete',
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  title: const Text('Delete'),
                                ),
                              ),
                            ],
                      );
                    },
                  ),
                ),
              ],
              pinned: true,
              expandedHeight: 700,
              floating: true,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                background: LayoutBuilder(
                  builder: (context, constraints) {
                    var mqSize = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                    return Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.black,
                      ),
                      width: mqSize.width,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: 0.7,
                            child: CachedNetworkImage(
                              imageUrl: downloadsItem.imgUrl,
                              fit: BoxFit.cover,
                              height: mqSize.height,
                              width: mqSize.width,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
