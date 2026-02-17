import 'dart:developer';

import 'package:animated_item/animated_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/downloads_image_model.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20Image%20Page/view_img_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/view%20card%20detail%20page/widgets/photographer_detail_card.dart';
import 'package:pix_hunt_project/core/Utils/internet_checker_util.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20btns/app_main_btn.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ViewCardDetailsPage extends StatefulWidget {
  const ViewCardDetailsPage({super.key, required this.photos});
  static const pageName = '/view_detail_page';
  final Photos photos;

  @override
  State<ViewCardDetailsPage> createState() => _ViewCardDetailsPageState();
}

class _ViewCardDetailsPageState extends State<ViewCardDetailsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> scaleTitle,
      fadeTitle,
      scalePhotographer,
      fadePhotographer,
      scaleOverview,
      fadeOverview,
      scalePhotosBox,
      fadePhotosBox,
      scaleDownloadBtn,
      fadeDownloadBtn;

  late final PageController pageController;
  late final ValueNotifier<({String imgPath, String pixels})> firstNotifier;
  late final List<({String imgPath, String pixels})> dataList;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: 1);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    scaleTitle = _tweenAnimation(0.0, 0.2);
    fadeTitle = _tweenAnimation(0.0, 0.2, isFade: true);

    scalePhotographer = _tweenAnimation(0.2, 0.4);
    fadePhotographer = _tweenAnimation(0.2, 0.4, isFade: true);

    scaleOverview = _tweenAnimation(0.4, 0.6);
    fadeOverview = _tweenAnimation(0.4, 0.6, isFade: true);

    scalePhotosBox = _tweenAnimation(0.6, 0.8);
    fadePhotosBox = _tweenAnimation(0.6, 0.8, isFade: true);

    scaleDownloadBtn = _tweenAnimation(0.8, 1.0);
    fadeDownloadBtn = _tweenAnimation(0.8, 1.0, isFade: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
    });
  }

  Animation<double> _tweenAnimation(
    double start,
    double end, {
    bool isFade = false,
  }) {
    return Tween<double>(begin: isFade ? 0.0 : 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(start, end, curve: Curves.linear),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    firstNotifier.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('ViewCardDetailsPage build called');

    var lng = AppLocalizations.of(context);
    dataList = [
      (
        imgPath: widget.photos.originalImgUrl ?? '',
        pixels: lng?.pixels3k ?? '',
      ),
      (imgPath: widget.photos.largeImgUrl ?? '', pixels: lng?.pixels800 ?? ''),
      (imgPath: widget.photos.mediumImgUrl ?? '', pixels: lng?.pixels640 ?? ''),
      (imgPath: widget.photos.smallImgUrl ?? '', pixels: lng?.pixels400 ?? ''),
    ];

    firstNotifier = ValueNotifier(dataList[1]);

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          _buildCloseButton(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildPhotographerCard(),
                _buildPageView(),
                _buildThumbnailList(),
                _buildDownloadButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.xmark_circle_fill, size: 30),
        ),
      ],
    );
  }

  Widget _buildPhotographerCard() {
    return SliverToBoxAdapter(
      child: PhotographerDetailCard(
        title: widget.photos.title ?? '',
        photographer: widget.photos.photographer ?? '',
        fadeOverview: fadeOverview,
        fadePhotographer: fadePhotographer,
        fadeTitle: fadeTitle,
        scaleOverview: scaleOverview,
        scalePhotographer: scalePhotographer,
        scaleTitle: scaleTitle,
      ),
    );
  }

  Widget _buildPageView() {
    return SliverSafeArea(
      top: false,
      bottom: false,
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
                  onPageChanged:
                      (index) => firstNotifier.value = dataList[index],
                  itemBuilder: (context, index) => _buildPageViewItem(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageViewItem(int index) {
    var item = dataList[index];
    return AnimatedItem(
      controller: pageController,
      effect: const ScaleEffect(),
      index: index,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap:
              () => Navigator.pushNamed(
                context,
                ViewImagePage.pageName,
                arguments: item,
              ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: item.imgPath,
              fit: BoxFit.cover,
              progressIndicatorBuilder:
                  (context, url, progress) =>
                      const CupertinoActivityIndicator(),
              errorWidget:
                  (context, url, error) => const Icon(
                    Icons.wifi_off_rounded,
                    color: Color.fromARGB(255, 214, 21, 7),
                    size: 50,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailList() {
    return SliverSafeArea(
      top: false,
      bottom: false,
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        sliver: SliverToBoxAdapter(
          child: ValueListenableBuilder(
            valueListenable: firstNotifier,
            builder: (context, value, _) {
              return ScaleTransition(
                scale: scalePhotosBox,
                child: FadeTransition(
                  opacity: fadePhotosBox,
                  child: SizedBox(
                    height: 90,
                    width: 90,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,

                      itemCount: dataList.length,
                      itemBuilder:
                          (context, index) =>
                              _buildThumbnailItem(dataList[index], value),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailItem(
    ({String imgPath, String pixels}) item,
    ({String imgPath, String pixels}) selectedItem,
  ) {
    bool isSelected = selectedItem.imgPath == item.imgPath;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap:
            () => pageController.animateToPage(
              dataList.indexOf(item),
              duration: const Duration(seconds: 1),
              curve: Curves.easeInCirc,
            ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                  border:
                      isSelected
                          ? Border.all(color: Colors.indigo, width: 2)
                          : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Opacity(
                      opacity: isSelected ? 1.0 : 0.5,
                      child: CachedNetworkImage(
                        imageUrl: item.imgPath,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, progress) =>
                                const CupertinoActivityIndicator(),
                        errorWidget:
                            (context, url, error) => Container(
                              height: 70,
                              width: 70,
                              color: Colors.grey.withAlpha(100),
                              child: const Icon(
                                Icons.wifi_off_rounded,
                                color: Color.fromARGB(255, 214, 21, 7),
                              ),
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              item.pixels,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return SliverSafeArea(
      top: false,
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        sliver: SliverToBoxAdapter(
          child: Consumer(
            builder: (context, ref, _) {
              return ValueListenableBuilder(
                valueListenable: firstNotifier,
                builder: (context, value, _) {
                  return ScaleTransition(
                    scale: scaleDownloadBtn,
                    child: FadeTransition(
                      opacity: fadeDownloadBtn,
                      child: AppMainBtn(
                        widgetOrTitle: WidgetOrTitle.title,
                        btnTitle:
                            '${AppLocalizations.of(context)?.download ?? ''} (${value.pixels})',
                        onTap: () async => _downloadImage(ref, value),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _downloadImage(
    ref,
    ({String imgPath, String pixels}) value,
  ) async {
    var internet = await getIt<InternetCheckerUtil>().checkInternet();
    if (!internet) return;

    String id = DateTime.now().microsecondsSinceEpoch.toString();
    var result = await ref
        .read(userDbProvider.notifier)
        .addDownloadedPhotos(
          DownloadsImageModel(
            photographer: widget.photos.photographer ?? '',
            title: widget.photos.title ?? '',
            imgUrl: value.imgPath,
            pixels: value.pixels,
            id: id,
            date: DateTime.now().toString(),
          ),
          AppLocalizations.of(context)?.downloading ?? '',
          AppLocalizations.of(context)?.imageSavedToGallery ?? '',
        );

    if (result != null) {
      Fluttertoast.showToast(
        msg: result.message,
        backgroundColor: Colors.green,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.TOP,
      );
    }
  }
}
