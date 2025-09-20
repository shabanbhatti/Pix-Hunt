import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/dowloads_items_model.dart';

import 'package:pix_hunt_project/Models/fav_items.dart';
import 'package:pix_hunt_project/Pages/View%20Image%20Page%20(FAVOURITE)/view_fav_img_page.dart';
import 'package:pix_hunt_project/Pages/View%20card%20detail%20page%20(FAVOURITE)/Widgets/fav_img_download_card.dart';
import 'package:pix_hunt_project/Utils/download%20image%20Method/img_download.dart';
import 'package:pix_hunt_project/Widgets/Photographer%20detail%20card/photographer_detail_card.dart';
import 'package:pix_hunt_project/Widgets/custom_sliver_appbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewFavDetailPage extends StatelessWidget {
  const ViewFavDetailPage({super.key, required this.favItemModalClass});
  static const pageName = '/view_detail_page';
  final FavItemModalClass favItemModalClass;

  @override
  Widget build(BuildContext context) {
    print('VIEW CARD (FAV) BUILD CALLED');
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(title: favItemModalClass.title),
          SliverToBoxAdapter(
            child: PhotographerDetailCard(
              title: favItemModalClass.title,
              photographer: favItemModalClass.photographer,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 300,
              ),
              delegate: SliverChildListDelegate([
                _heroAnimCard(
                  favItemModalClass.originalPhotoUrl,
                  favItemModalClass,
                  'Full HD (3000+ pixels)',
                  context,
                  0,
                ),

                FavImgDownloadCard(
                  imgLink: favItemModalClass.largePhotoUrl,
                  favItemModalClass: favItemModalClass,
                  index: 1,
                  pixels: '800 pixels',
                ),

                FavImgDownloadCard(
                  imgLink: favItemModalClass.mediumPhotoUrl,
                  favItemModalClass: favItemModalClass,
                  index: 2,
                  pixels: '640 pixels',
                ),

                FavImgDownloadCard(
                  imgLink: favItemModalClass.smallPhotoUrl,
                  favItemModalClass: favItemModalClass,
                  index: 3,
                  pixels: '400 pixels',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _heroAnimCard(
  String imgLink,
  FavItemModalClass favItemModalClass,
  String pixels,
  BuildContext context,
  int index,
) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: Consumer(
      builder: (context, ref, child) {
        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
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
                    child: Hero(
                      tag: favItemModalClass.originalPhotoUrl,
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
                               const Icon(Icons.wifi_off, color: Colors.red),
                        height: 200,
                      ),
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
                                                        favItemModalClass
                                                            .photographer,
                                                    title:
                                                        favItemModalClass.title,
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
