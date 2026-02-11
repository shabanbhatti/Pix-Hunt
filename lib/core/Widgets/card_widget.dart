import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/fav_items.dart';
import 'package:pix_hunt_project/Models/pexer.dart';
import 'package:pix_hunt_project/Pages/view%20card%20detail%20page/view_card_detail_page.dart';
import 'package:pix_hunt_project/Pages/View%20home%20cetagory%20Page/view_page.dart';
import 'package:pix_hunt_project/core/Utils/bottom%20sheets/half_size_bottom_sheet_util.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.photo, required this.index});

  final Photo photo;
  final int index;
  @override
  Widget build(BuildContext context) {
    var lng = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () {
        openHalfBottomSheet(
          context,
          child: ViewCardDetailsPage(
            favItemModalClass: FavItemModalClass(
              photographer: photo.photographer,
              title: photo.alt,
              originalPhotoUrl: photo.src.original,
              mediumPhotoUrl: photo.src.medium,
              largePhotoUrl: photo.src.large,
              smallPhotoUrl: photo.src.small,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsetsGeometry.all(5),
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.grey.withAlpha(50),
          ),

          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 25,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Hero(
                      tag: photo.src.original,
                      child: CachedNetworkImage(
                        imageUrl: photo.src.medium,
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
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 10,
                  child: Text(
                    photo.alt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    photo.photographer,
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
                          var myRef = ref.watch(isFavouriteProvider(index));
                          return IconButton(
                            onPressed: () {
                              ref
                                  .read(isFavouriteProvider(index).notifier)
                                  .toggled();
                              String id =
                                  DateTime.now().microsecondsSinceEpoch
                                      .toString();
                              if (myRef == false) {
                                ref
                                    .read(userDbProvider.notifier)
                                    .addFavouriteItems(
                                      FavItemModalClass(
                                        title: photo.alt,
                                        photographer: photo.photographer,
                                        originalPhotoUrl: photo.src.original,
                                        mediumPhotoUrl: photo.src.medium,
                                        largePhotoUrl: photo.src.large,
                                        smallPhotoUrl: photo.src.small,
                                        id: id,
                                      ),
                                    );
                                ToastUtils.showToast(
                                  '${lng?.itemAddedToFavorite ?? ''} 💙',
                                  color: Colors.green,
                                );
                              }
                            },
                            icon: Icon(
                              (myRef)
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: (myRef) ? Colors.indigo : null,
                              size: 25,
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
