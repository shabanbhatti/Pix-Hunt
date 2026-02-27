import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/ads%20controller/interstitial_add_controller.dart';
import 'package:pix_hunt_project/Controllers/api%20controller/api_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20controller/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20home%20cetagory%20Page/Widgets/photo_pages_widget.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/Widgets/card_widget.dart';
import 'package:pix_hunt_project/core/Widgets/custom_sliver_appbar.dart';
import 'package:pix_hunt_project/core/Widgets/loading%20widgets/custom_loading_card_widget.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewContentPage extends ConsumerStatefulWidget {
  const ViewContentPage({
    super.key,
    required this.constListProducts,
    this.title,
  });
  static const pageName = '/view_content';

  final BoxModel constListProducts;
  final String? title;
  @override
  ConsumerState<ViewContentPage> createState() => _ViewContentPageState();
}

class _ViewContentPageState extends ConsumerState<ViewContentPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack),
    );

    if (widget.title == null) {
      Future.microtask(() {
        ref
            .read(apiProvider.notifier)
            .fetchData(search: widget.constListProducts.title, pageNumber: 1);
        ref.read(interstitialAdProvider.notifier).initInterstitialAds();
      });
    } else {
      Future.microtask(() {
        ref
            .read(apiProvider.notifier)
            .fetchData(search: widget.title, pageNumber: 1);
      });
    }
  }

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('View Home cetagory page build called');
    ref.listen(apiProvider, (previous, next) {
      if (next is ApiLoadedSuccessfuly) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          animationController.forward();
        });
      }
    });
    ref.listen(userDbProvider, (previous, next) {
      if (next is ErrorUserDb) {
        var error = next.error;

        ToastUtils.showToast(error, color: Colors.red);
        if (error == 'Session expired. Please sign in again.') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.pageName,
            (route) => false,
          );
        }
      }
    });
    return Scaffold(
      body: Center(
        child: RefreshIndicator(
          color: ConstantColors.appColor,
          onRefresh: () {
            if (widget.title == null) {
              return ref
                  .read(apiProvider.notifier)
                  .fetchFromApi(
                    search: widget.constListProducts.title,
                    pageNumber: 1,
                  );
            } else {
              return ref
                  .read(apiProvider.notifier)
                  .fetchFromApi(search: widget.title, pageNumber: 1);
            }
          },
          child: Scrollbar(
            controller: scrollController,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                if (widget.title == null)
                  CustomSliverAppBar(title: widget.constListProducts.title)
                else
                  CustomSliverAppBar(title: widget.title ?? ''),
                SliverSafeArea(
                  top: false,

                  sliver: Consumer(
                    builder: (context, apiRef, child) {
                      var myRef = apiRef.watch(apiProvider);
                      if (myRef is ApiLoading) {
                        return _loading();
                      } else if (myRef is ApiLoadedSuccessfuly) {
                        return _cardData(myRef.pexer, scale);
                      } else if (myRef is ApiError) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Text(
                              myRef.message,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SliverToBoxAdapter();
                      }
                    },
                  ),
                ),
                Consumer(
                  builder: (context, x, child) {
                    var myRef = x.watch(apiProvider);
                    if (myRef is ApiLoadedSuccessfuly) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: PhotoPagesWidget(
                            title:
                                (widget.title == null)
                                    ? widget.constListProducts.title
                                    : widget.title ?? '',
                            pexer: myRef.pexer,
                            scrollController: scrollController,
                          ),
                        ),
                      );
                    } else {
                      return const SliverToBoxAdapter();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardData(Pexer pexer, Animation<double> scale) {
    List<Photos> photosList = pexer.photosList ?? [];
    return SliverPadding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 10),
      sliver: SliverGrid.builder(
        itemCount: photosList.length,
        itemBuilder: (context, index) {
          final start = (index * 0.05).clamp(0.0, 1.0);
          final end = (start + 0.4).clamp(0.0, 1.0);

          final animation = CurvedAnimation(
            parent: animationController,
            curve: Interval(start, end, curve: Curves.easeOutBack),
          );
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.25),
                end: Offset.zero,
              ).animate(animation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
                child: CardWidget(photo: photosList[index], index: index),
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 1,
          mainAxisExtent: 290,
        ),
      ),
    );
  }
}

List<String> lodingList = List.generate(
  20,
  (index) => 'My Data is here the loading Data. DO you wanna access',
);
Widget _loading() {
  return SliverPadding(
    padding: const EdgeInsets.all(5),
    sliver: SliverGrid.builder(
      itemCount: lodingList.length,
      itemBuilder:
          (context, index) =>
              const Skeletonizer(child: const CustomLoadingCardsWidget()),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        mainAxisExtent: 290,
      ),
    ),
  );
}

final isFavouriteProvider = StateNotifierProvider.family
    .autoDispose<IsFavouritedNotifier, bool, int>((ref, index) {
      return IsFavouritedNotifier();
    });

class IsFavouritedNotifier extends StateNotifier<bool> {
  IsFavouritedNotifier() : super(false);

  void toggled() {
    state = !state;
  }
}
