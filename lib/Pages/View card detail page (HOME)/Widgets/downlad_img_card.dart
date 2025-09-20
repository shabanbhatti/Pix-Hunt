import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/dowloads_items_model.dart';
import 'package:pix_hunt_project/Models/pexer.dart';

import 'package:pix_hunt_project/Pages/View%20Image%20Page%20(HOME)/view_image_page.dart';
import 'package:pix_hunt_project/Utils/download%20image%20Method/img_download.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DownloadImgCard extends StatelessWidget {
  const DownloadImgCard({
    super.key,
    required this.imgLink,
    required this.index,
    required this.photo,
    required this.pixels,
  });

  final String imgLink;
  final Photo photo;
  final String pixels;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Consumer(
        builder: (context, ref, child) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                ViewImagePage.pageName,
                arguments:
                    {'object': photo, 'index': index} as Map<String, dynamic>,
              );
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    flex: 20,
                    child: CachedNetworkImage(
                      imageUrl: imgLink,
                      fit: BoxFit.cover,
                      fadeInDuration: Duration(milliseconds: 300),
                      placeholder:
                          (context, url) => Skeletonizer(
                            enabled: true,
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              color: Colors.grey[700],
                            ),
                          ),
                      errorWidget:
                          (context, url, error) =>
                              Icon(Icons.wifi_off, color: Colors.red),
                      height: 200,
                    ),
                  ),
                  Expanded(flex: 3, child: Text(pixels)),

                  Expanded(
                    flex: 3,
                    child: Consumer(
                      builder: (context, ref, child) {
                        return IconButton(
                          onPressed: () async {
                            ref.read(downloadProgressProvider.notifier).state =
                                0.0;

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Consumer(
                                  builder: (dialogContext, dialogRef, child) {
                                    final progress = dialogRef.watch(
                                      downloadProgressProvider,
                                    );
                                    print('CALLED CONSUMER');

                                    String id =
                                        DateTime.now().microsecondsSinceEpoch
                                            .toString();
                                    if (progress == 1.0) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            ref
                                                .read(userDbProvider.notifier)
                                                .addDownloadedPhotos(
                                                  DownloadsItem(
                                                    photographer:
                                                        photo.photographer,
                                                    title: photo.alt,
                                                    imgUrl: imgLink,
                                                    pixels: pixels,
                                                    id: id,
                                                    date:
                                                        DateTime.now()
                                                            .toString(),
                                                  ),
                                                )
                                                .then((value) {
                                                  if (dialogContext.mounted) {
                                                    Navigator.pop(
                                                      dialogContext,
                                                    );
                                                  }
                                                });
                                          });
                                    }

                                    return AlertDialog(
                                      title: const Center(
                                        child: Text('Downloading'),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${((progress ?? 0) * 100).toStringAsFixed(0)}%',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          LinearProgressIndicator(
                                            value: progress,
                                            backgroundColor: Colors.grey[200],
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.indigo,
                                                ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );

                            await downloadImage(imgLink, context, ref);
                          },
                          icon: const Icon(
                            Icons.download,
                            color: Colors.indigo,
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(flex: 1),
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Tap to view image',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
