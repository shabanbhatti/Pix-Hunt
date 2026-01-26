import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';

import 'package:pix_hunt_project/Models/fav_items.dart';
import 'package:pix_hunt_project/Pages/view%20card%20detail%20page/view_card_detail_page.dart';

import 'package:pix_hunt_project/Utils/bottom%20sheets/half_size_bottom_sheet_util.dart';
import 'package:pix_hunt_project/Widgets/custom_dialog_boxes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavCardWidget extends StatelessWidget {
  const FavCardWidget({super.key, required this.favItem});

  final FavItemModalClass favItem;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(
        //   context,
        // ).pushNamed(ViewCardDetailsPage.pageName, arguments: favItem);
        openHalfBottomSheet(
          context,
          child: ViewCardDetailsPage(favItemModalClass: favItem),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.grey.withAlpha(50),
          ),
          child: Padding(
            padding: EdgeInsets.all(7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 25,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: favItem.mediumPhotoUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 300),
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
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 10,
                  child: Text(
                    favItem.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    favItem.photographer,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          return IconButton(
                            onPressed: () {
                              removeFavoritesItemsDialog(context, () {
                                ref
                                    .read(userDbProvider.notifier)
                                    .deleteFavourites(favItem);
                              });
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.indigo,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
