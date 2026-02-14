import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/api%20Riverpod/api_riverpod.dart';
import 'package:pix_hunt_project/Models/pexer.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20home%20cetagory%20Page/Widgets/photo_pages_widget.dart';
import 'package:pix_hunt_project/core/Widgets/card_widget.dart';
import 'package:pix_hunt_project/core/Widgets/custom_sliver_appbar.dart';
import 'package:pix_hunt_project/core/Widgets/loading_card_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewContentPage extends ConsumerStatefulWidget {
  const ViewContentPage({
    super.key,
    required this.constListProducts,
    this.title,
  });
  static const pageName = '/view_content';

  final ({String title, String imgPath}) constListProducts;
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
    scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.bounceOut),
    );

    if (widget.title == null) {
      Future.microtask(() {
        ref
            .read(apiProvider.notifier)
            .fetchApi(search: widget.constListProducts.title, pageNumber: 1);
      });
    } else {
      Future.microtask(() {
        ref
            .read(apiProvider.notifier)
            .fetchApi(search: widget.title, pageNumber: 1);
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
      // print('PREVIOUS: ${previous.runtimeType} | NEXT: ${next.runtimeType}');
      if (next is ApiLoadedSuccessfuly) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          animationController.forward();
        });
      }
    });
    return Scaffold(
      body: Center(
        child: RefreshIndicator(
          color: Colors.indigo,
          onRefresh: () {
            if (widget.title == null) {
              return ref
                  .read(apiProvider.notifier)
                  .fetchApi(
                    search: widget.constListProducts.title,
                    pageNumber: 1,
                  );
            } else {
              return ref
                  .read(apiProvider.notifier)
                  .fetchApi(search: widget.title, pageNumber: 1);
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
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
    return SliverPadding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 10),
      sliver: SliverGrid.builder(
        itemCount: pexer.photos.length,
        itemBuilder:
            (context, index) => ScaleTransition(
              scale: scale,
              child: CardWidget(photo: pexer.photos[index], index: index),
            ),
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
          (context, index) => const Skeletonizer(child: const LoadingWidget()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
