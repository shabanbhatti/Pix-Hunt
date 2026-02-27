import 'dart:developer';
import 'package:animated_item/animated_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20Image%20Page/view_img_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/view%20card%20detail%20page/widgets/card_detail_download_btn.dart';
import 'package:pix_hunt_project/Pages/home%20screens/view%20card%20detail%20page/widgets/photographer_detail_card.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ViewCardDetailsPage extends ConsumerStatefulWidget {
  const ViewCardDetailsPage({super.key, required this.photos});
  static const pageName = '/view_detail_page';
  final Photos photos;

  @override
  ConsumerState<ViewCardDetailsPage> createState() =>
      _ViewCardDetailsPageState();
}

class _ViewCardDetailsPageState extends ConsumerState<ViewCardDetailsPage>
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
  late final ValueNotifier<ImageModel> firstNotifier;
  late final List<ImageModel> dataList;

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
                ViewCardDetailDownloadBtn(
                  firstNotifier: firstNotifier,
                  scaleDownloadBtn: scaleDownloadBtn,
                  fadeDownloadBtn: fadeDownloadBtn,
                  photos: widget.photos,
                ),
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
          onPressed: () {
            EasyLoading.dismiss();
            Navigator.pop(context);
          },
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
                          ? Border.all(color: ConstantColors.appColor, width: 2)
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
}
