import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/api%20controller/api_riverpod.dart';
import 'package:pix_hunt_project/Controllers/on%20sync%20after%20email%20verify%20riverpod/on_sync_after_email_verify.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Search%20page/Widgets/search_photos_pages_widget.dart';
import 'package:pix_hunt_project/core/Widgets/card_widget.dart';
import 'package:pix_hunt_project/core/Widgets/loading%20widgets/custom_loading_card_widget.dart';
import 'package:pix_hunt_project/core/Widgets/sliverappbar_with_textfield.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key, this.isBottomNaviSearchPage = false});
  static const pageName = '/search_page';
  final bool isBottomNaviSearchPage;

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
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

    Future.microtask(() async {
      ref
          .read(onSyncAfterEmailVerifyProvider.notifier)
          .syncEmailAfterVerification();
      ref.read(apiProvider.notifier).eraseAll();
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    searchKeyworkNotifier.dispose();
    animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  ValueNotifier<String> searchKeyworkNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    log('Search page build called');

    ref.listen(apiProvider, (previous, next) {
      if (next is ApiLoading) {
        animationController.reverse();
      }
      if (next is ApiLoadedSuccessfuly) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          animationController.forward();
        });
      }
    });
    return Scaffold(
      body: Center(
        child: Scrollbar(
          controller: scrollController,
          radius: Radius.circular(20),
          thickness: 5,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverappbarWithTextField(
                isForSearchPage: true,
                animationController: animationController,
                controller: controller,
                searchKeyword: searchKeyworkNotifier,
                focusNode: focusNode,
                isBottomNaviSearchPage: widget.isBottomNaviSearchPage,
              ),
              SliverSafeArea(
                top: false,
                bottom: false,
                sliver: ValueListenableBuilder(
                  valueListenable: searchKeyworkNotifier,
                  builder: (context, value, child) {
                    if (value.isNotEmpty) {
                      return SliverPadding(
                        padding: const EdgeInsetsGeometry.only(
                          left: 10,
                          top: 10,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            children: [
                              Text(
                                '${AppLocalizations.of(context)?.searchResult ?? ''}: ',
                              ),
                              Expanded(
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  value,
                                  style: const TextStyle(
                                    color: ConstantColors.appColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SliverToBoxAdapter();
                    }
                  },
                ),
              ),

              SliverSafeArea(
                top: false,
                sliver: Consumer(
                  builder: (context, apiProviderRef, child) {
                    var myRef = apiProviderRef.watch(apiProvider);
                    if (myRef is ApiLoading) {
                      return _loading();
                    } else if (myRef is ApiLoadedSuccessfuly) {
                      return _cardData(myRef.pexer);
                    } else if (myRef is ApiError) {
                      print(myRef.message);
                      return SliverFillRemaining(
                        child: Center(
                          child: Text(
                            myRef.message,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    } else {
                      return SliverFillRemaining(
                        child: Center(child: _noSearchYet(context)),
                      );
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
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SearchPhotosPagesWidget(
                          controller: controller,
                          scrollController: scrollController,
                          pexer: myRef.pexer,
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
    );
  }

  Widget _cardData(Pexer pexer) {
    List<Photos> photosList = pexer.photosList ?? [];
    return SliverPadding(
      padding: const EdgeInsets.all(5),
      sliver: SliverGrid.builder(
        itemCount: photosList.length,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          mainAxisExtent: 290,
        ),
        itemBuilder: (context, index) {
          return ScaleTransition(
            scale: scale,
            child: CardWidget(photo: photosList[index], index: index),
          );
        },
      ),
    );
  }
}

Widget _noSearchYet(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.search),
      Text(
        ' ${AppLocalizations.of(context)?.searchContentHere ?? ''} ',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  );
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
