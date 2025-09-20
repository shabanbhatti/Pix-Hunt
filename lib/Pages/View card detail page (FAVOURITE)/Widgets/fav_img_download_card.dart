import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/dowloads_items_model.dart';
import 'package:pix_hunt_project/Models/fav_items.dart';
import 'package:pix_hunt_project/Pages/View%20Image%20Page%20(FAVOURITE)/view_fav_img_page.dart';
import 'package:pix_hunt_project/Utils/download%20image%20Method/img_download.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavImgDownloadCard extends StatelessWidget {
  const FavImgDownloadCard({
    super.key,
    required this.imgLink,
    required this.favItemModalClass,
    required this.index,
    required this.pixels,
  });
  final String imgLink;
  final FavItemModalClass favItemModalClass;
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
                ViewFavImagePage.pageName,
                arguments:
                    {'object': favItemModalClass, 'index': index}
                        as Map<String, dynamic>,
              );
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    Spacer(flex: 1),
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
                              ref
                                  .read(downloadProgressProvider.notifier)
                                  .state = 0.0;

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
                                                          favItemModalClass
                                                              .photographer,
                                                      title:
                                                          favItemModalClass
                                                              .title,
                                                      date:
                                                          DateTime.now()
                                                              .toString(),
                                                      imgUrl:
                                                          favItemModalClass
                                                              .smallPhotoUrl,
                                                      pixels: pixels,
                                                      id: id,
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
            ),
          );
        },
      ),
    );
  }
}
