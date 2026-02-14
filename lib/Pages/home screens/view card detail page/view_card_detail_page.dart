import 'dart:developer';

import 'package:animated_item/animated_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/dowloads_items_model.dart';
import 'package:pix_hunt_project/Models/fav_items.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20Image%20Page/view_img_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/view%20card%20detail%20page/widgets/photographer_detail_card.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20btns/app_main_btn.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ViewCardDetailsPage extends StatefulWidget {
  const ViewCardDetailsPage({super.key, required this.favItemModalClass});
  static const pageName = '/view_detail_page';
  final FavItemModalClass favItemModalClass;

  @override
  State<ViewCardDetailsPage> createState() => _ViewCardDetailsPageState();
}

class _ViewCardDetailsPageState extends State<ViewCardDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late List<({String imgPath, String pixels})> dataList;
  late ValueNotifier<({String imgPath, String pixels})> firstNotifier;
  late Animation<double> scaleTitle;
  late Animation<double> fadeTitle;
  late Animation<double> scalePhotographer;
  late Animation<double> fadePhotographer;
  late Animation<double> scaleOverview;
  late Animation<double> fadeOverview;

  late Animation<double> scalePhotosBox;
  late Animation<double> fadePhotosBox;

  late Animation<double> scaleDownloadBtn;
  late Animation<double> fadeDownloadBtn;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    fadeTitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.2),
      ),
    );

    scaleTitle = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.2, curve: Curves.linear),
      ),
    );

    scalePhotographer = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.4),
      ),
    );

    fadePhotographer = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.4, curve: Curves.linear),
      ),
    );

    scaleOverview = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 0.6),
      ),
    );

    fadeOverview = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 0.6, curve: Curves.linear),
      ),
    );

    scalePhotosBox = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 0.8),
      ),
    );

    fadePhotosBox = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 0.8, curve: Curves.linear),
      ),
    );

    scaleDownloadBtn = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.8, 1.0),
      ),
    );

    fadeDownloadBtn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.8, 1.0, curve: Curves.linear),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward();
    });
  }

  PageController pageController = PageController(initialPage: 1);

  @override
  void dispose() {
    pageController.dispose();
    firstNotifier.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('View card deatil page build called');
    var lng = AppLocalizations.of(context);
    firstNotifier = ValueNotifier((
      imgPath: widget.favItemModalClass.largePhotoUrl,
      pixels: lng?.pixels800 ?? '',
    ));
    dataList = [
      (
        imgPath: widget.favItemModalClass.originalPhotoUrl,
        pixels: lng?.pixels3k ?? '',
      ),
      (
        imgPath: widget.favItemModalClass.largePhotoUrl,
        pixels: lng?.pixels800 ?? '',
      ),
      (
        imgPath: widget.favItemModalClass.mediumPhotoUrl,
        pixels: lng?.pixels640 ?? '',
      ),
      (
        imgPath: widget.favItemModalClass.smallPhotoUrl,
        pixels: lng?.pixels400 ?? '',
      ),
    ];
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(CupertinoIcons.xmark_circle_fill, size: 30),
              ),
            ],
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: PhotographerDetailCard(
                    title: widget.favItemModalClass.title,
                    photographer: widget.favItemModalClass.photographer,
                    fadeOverview: fadeOverview,
                    fadePhotographer: fadePhotographer,
                    fadeTitle: fadeTitle,
                    scaleOverview: scaleOverview,
                    scalePhotographer: scalePhotographer,
                    scaleTitle: scaleTitle,
                  ),
                ),

                SliverSafeArea(
                  top: false,

                  bottom: false,
                  sliver: SliverPadding(
                    padding: const EdgeInsetsGeometry.symmetric(vertical: 10),
                    sliver: SliverToBoxAdapter(
                      child: ScaleTransition(
                        scale: scaleOverview,
                        child: FadeTransition(
                          opacity: fadeOverview,
                          child: SizedBox(
                            height: 220,
                            child: PageView.builder(
                              controller: pageController,
                              itemCount: dataList.length,
                              onPageChanged: (value) {
                                firstNotifier.value = dataList[value];
                              },
                              itemBuilder: (context, index) {
                                return AnimatedItem(
                                  controller: pageController,
                                  effect: ScaleEffect(),
                                  index: index,
                                  child: Padding(
                                    padding: EdgeInsetsGeometry.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          ViewImagePage.pageName,
                                          arguments: dataList[index],
                                        );
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: Container(
                                          height: 200,
                                          width: double.infinity,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: dataList[index].imgPath,
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder:
                                                (context, url, progress) =>
                                                    CupertinoActivityIndicator(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverSafeArea(
                  top: false,
                  bottom: false,
                  sliver: SliverPadding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: ValueListenableBuilder(
                        valueListenable: firstNotifier,
                        builder: (context, value, child) {
                          return ScaleTransition(
                            scale: scalePhotosBox,
                            child: FadeTransition(
                              opacity: fadePhotosBox,
                              child: Container(
                                height: 90,

                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: dataList.length,
                                  itemBuilder: (context, index) {
                                    var e = dataList[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsetsGeometry.symmetric(
                                            horizontal: 5,
                                          ),
                                      child: GestureDetector(
                                        onTap: () {
                                          pageController.animateToPage(
                                            index,
                                            duration: Duration(seconds: 1),
                                            curve: Curves.bounceOut,
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(7),
                                                      ),
                                                  border:
                                                      value.imgPath == e.imgPath
                                                          ? Border.all(
                                                            color:
                                                                Colors.indigo,
                                                            width: 2,
                                                          )
                                                          : null,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsGeometry.all(
                                                        1.3,
                                                      ),
                                                  child: Container(
                                                    height: 70,
                                                    width: 70,
                                                    clipBehavior:
                                                        Clip.antiAliasWithSaveLayer,
                                                    decoration:
                                                        const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  5,
                                                                ),
                                                              ),
                                                        ),
                                                    child: Opacity(
                                                      opacity:
                                                          value.imgPath ==
                                                                  e.imgPath
                                                              ? 1.0
                                                              : 0.5,
                                                      child: CachedNetworkImage(
                                                        imageUrl: e.imgPath,
                                                        fit: BoxFit.cover,
                                                        progressIndicatorBuilder:
                                                            (
                                                              context,
                                                              url,
                                                              progress,
                                                            ) =>
                                                                const CupertinoActivityIndicator(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Text(
                                              e.pixels,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SliverSafeArea(
                  top: false,
                  sliver: SliverPadding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Consumer(
                        builder: (context, ref, _) {
                          return ValueListenableBuilder(
                            valueListenable: firstNotifier,
                            builder: (context, value, child) {
                              return ScaleTransition(
                                scale: scaleDownloadBtn,
                                child: FadeTransition(
                                  opacity: fadeDownloadBtn,
                                  child: AppMainBtn(
                                    onTap: () async {
                                      String id =
                                          DateTime.now().microsecondsSinceEpoch
                                              .toString();
                                      var isDownloaded = await ref
                                          .read(userDbProvider.notifier)
                                          .addDownloadedPhotos(
                                            DownloadsItem(
                                              photographer:
                                                  widget
                                                      .favItemModalClass
                                                      .photographer,
                                              title:
                                                  widget
                                                      .favItemModalClass
                                                      .title,
                                              imgUrl: value.imgPath,
                                              pixels: value.pixels,
                                              id: id,
                                              date: DateTime.now().toString(),
                                            ),
                                            AppLocalizations.of(
                                                  context,
                                                )?.downloading ??
                                                '',
                                            AppLocalizations.of(
                                                  context,
                                                )?.imageSavedToGallery ??
                                                '',
                                          );

                                      if (isDownloaded != null) {
                                        if (isDownloaded.isDownloade) {
                                          Fluttertoast.showToast(
                                            msg: isDownloaded.message,
                                            backgroundColor: Colors.green,
                                            timeInSecForIosWeb: 3,
                                            gravity: ToastGravity.TOP,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: isDownloaded.message,
                                            backgroundColor: Colors.green,
                                            timeInSecForIosWeb: 3,
                                            gravity: ToastGravity.TOP,
                                          );
                                        }
                                      }
                                    },
                                    widgetOrTitle: WidgetOrTitle.title,
                                    btnTitle:
                                        '${AppLocalizations.of(context)?.download ?? ''} (${value.pixels})',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
