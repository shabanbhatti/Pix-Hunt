import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/dowloads_items_model.dart';
import 'package:pix_hunt_project/Models/pexer.dart';
import 'package:pix_hunt_project/Pages/View%20Image%20Page%20(HOME)/view_image_page.dart';
import 'package:pix_hunt_project/Utils/download%20image%20Method/img_download.dart';
import 'package:pix_hunt_project/Pages/View%20card%20detail%20page%20(HOME)/Widgets/downlad_img_card.dart';
import 'package:pix_hunt_project/Widgets/Photographer%20detail%20card/photographer_detail_card.dart';
import 'package:pix_hunt_project/Widgets/custom_sliver_appbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewCardPage extends StatelessWidget {
  const ViewCardPage({super.key, required this.photo});
  static const pageName = '/view_card_page';
  final Photo photo;

  @override
  Widget build(BuildContext context) {
    print('VIEW CARD (HOME) BUILD CALLED');
    return Scaffold(
      body: Scrollbar(
        radius: Radius.circular(20),
        thickness: 5,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(title: photo.alt),
            SliverToBoxAdapter(
              child: PhotographerDetailCard(
                title: photo.alt,
                photographer: photo.photographer,
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
                    photo.src.original,
                    photo,
                    'Full HD (3000+ pixels)',
                    context,
                    0,
                  ),
                  DownloadImgCard(imgLink: photo.src.large, index: 1, photo: photo, pixels: '800 pixels'),
                  DownloadImgCard(imgLink: photo.src.medium, index: 2, photo: photo, pixels: '640 pixels'),
                  DownloadImgCard(imgLink: photo.src.small, index: 3, photo: photo, pixels: '400 pixels'),
                  
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



Widget _heroAnimCard(
  String imgLink,
  Photo photo,
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
                  child: Hero(
                    tag: photo.src.original,
                    child: CachedNetworkImage(
                      imageUrl: imgLink,
                      fit: BoxFit.cover,
                      fadeInDuration: Duration(milliseconds: 300),
                      placeholder:
                            (context, url) =>  Skeletonizer(
                              enabled: true,
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.grey[700],
                              ),
                            ),
                      errorWidget: (context, url, error) =>const Icon(Icons.wifi_off, color: Colors.red,),
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
                                                  photo.photographer,
                                                  title: photo.alt,
                                                  imgUrl: imgLink,
                                                  pixels: pixels,
                                                  id: id,
                                                  date: DateTime.now().toString()
                                                ),
                                              )
                                              .then((value) {
                                                if (dialogContext.mounted) {
                                                  Navigator.pop(dialogContext);
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
                        icon: const Icon(Icons.download, color: Colors.indigo),
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
