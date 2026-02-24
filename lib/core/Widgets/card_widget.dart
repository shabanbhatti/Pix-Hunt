import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/api%20controller/api_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20controller/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Pages/home%20screens/view%20card%20detail%20page/view_card_detail_page.dart';
import 'package:pix_hunt_project/core/Utils/bottom%20sheets/half_size_bottom_sheet_util.dart';
import 'package:pix_hunt_project/core/Utils/internet_checker_util.dart';

import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardWidget extends ConsumerStatefulWidget {
  const CardWidget({super.key, required this.photo, required this.index});

  final Photos photo;
  final int index;

  @override
  ConsumerState<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends ConsumerState<CardWidget> {
  ValueNotifier<bool?> isToggeled = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    var lng = AppLocalizations.of(context);
    isToggeled.value = widget.photo.isBookmarked;
    return GestureDetector(
      onTap: () {
        openHalfBottomSheet(
          context,
          child: ViewCardDetailsPage(photos: widget.photo),
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
                      tag: widget.photo.originalImgUrl ?? '',
                      child: CachedNetworkImage(
                        imageUrl: widget.photo.mediumImgUrl ?? '',
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
                            (context, url, error) => Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.withAlpha(100),
                              ),
                              child: const Icon(
                                Icons.wifi_off_rounded,
                                color: const Color.fromARGB(255, 214, 21, 7),
                                size: 30,
                              ),
                            ),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 10,
                  child: Text(
                    widget.photo.describtion ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    widget.photo.photographer ?? '',
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
                      ValueListenableBuilder(
                        valueListenable: isToggeled,
                        builder: (context, value, child) {
                          return IconButton(
                            onPressed: () async {
                              if (value == false) {
                                isToggeled.value = true;
                              } else {
                                isToggeled.value = false;
                              }
                              var internet =
                                  await getIt<InternetCheckerUtil>()
                                      .checkInternet();
                              if (internet) {
                                if (value == false) {
                                  isToggeled.value = true;
                                  await ref
                                      .read(apiProvider.notifier)
                                      .updatePhoto(
                                        widget.photo.copyWith(
                                          isBookMarkedx: true,
                                        ),
                                      );

                                  ref
                                      .read(userDbProvider.notifier)
                                      .addFavouriteItems(
                                        widget.photo.copyWith(
                                          createdAt: DateTime.now().toString(),
                                        ),
                                      );

                                  ToastUtils.showToast(
                                    '${lng?.itemAddedToBookmark ?? ''}',
                                  );
                                } else {
                                  isToggeled.value = false;
                                  await ref
                                      .read(userDbProvider.notifier)
                                      .deleteBookmarkItem(widget.photo);
                                  await ref
                                      .read(apiProvider.notifier)
                                      .updatePhoto(
                                        widget.photo.copyWith(
                                          isBookMarkedx: false,
                                        ),
                                      );
                                }
                              } else {
                                isToggeled.value = isToggeled.value!;
                              }
                            },
                            icon: Icon(
                              (value ?? false)
                                  ? Icons.bookmark_outlined
                                  : Icons.bookmark_outline_rounded,

                              color:
                                  (value ?? false)
                                      ? ConstantColors.appColor
                                      : null,
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
