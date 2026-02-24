import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/api%20controller/api_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20controller/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Pages/home%20screens/view%20card%20detail%20page/view_card_detail_page.dart';

import 'package:pix_hunt_project/core/Utils/bottom%20sheets/half_size_bottom_sheet_util.dart';
import 'package:pix_hunt_project/core/Utils/date_format_util.dart';
import 'package:pix_hunt_project/core/Utils/dialog%20boxes/remove_bookmark_dialog_box.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookmarkCardWidget extends StatelessWidget {
  const BookmarkCardWidget({super.key, required this.photos});

  final Photos photos;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openHalfBottomSheet(
          context,
          child: ViewCardDetailsPage(photos: photos),
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
            padding: const EdgeInsets.all(7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 25,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: photos.mediumImgUrl ?? '',
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

                Expanded(
                  flex: 10,
                  child: Text(
                    photos.describtion ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    photos.photographer ?? '',
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
                      const Spacer(flex: 2),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsetsGeometry.only(left: 10),
                          child: Text(
                            DateFormatUtil.dateFormat(photos.createdAt ?? ''),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Consumer(
                          builder: (context, ref, child) {
                            return IconButton(
                              onPressed: () {
                                removeBookmarkItemDialog(context, () async {
                                  await ref
                                      .read(apiProvider.notifier)
                                      .updatePhoto(
                                        photos.copyWith(isBookMarkedx: false),
                                      );
                                  await ref
                                      .read(userDbProvider.notifier)
                                      .deleteBookmarkItem(photos);
                                });
                              },
                              icon: const Icon(
                                Icons.bookmark,
                                color: ConstantColors.appColor,
                                size: 30,
                              ),
                            );
                          },
                        ),
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
