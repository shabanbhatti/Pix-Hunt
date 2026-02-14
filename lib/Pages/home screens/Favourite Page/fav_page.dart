import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/Fav%20page%20Stream%20riverpod/fav_riverpod.dart';
import 'package:pix_hunt_project/Models/fav_items.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Favourite%20Page/Widgets/fav_card_widget.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Favourite%20Page/Widgets/fav_loading_widget.dart';
import 'package:pix_hunt_project/core/Widgets/sliverappbar_with_textfield.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavPage extends ConsumerStatefulWidget {
  const FavPage({super.key});
  static const pageName = '/fav_page';

  @override
  ConsumerState<FavPage> createState() => _FavPageState();
}

class _FavPageState extends ConsumerState<FavPage>
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

    controller.addListener(() {
      ref.read(searchListProvider.notifier).search(controller.text);
    });
  }

  ValueNotifier<String> searchKeyworkNotifier = ValueNotifier('');
  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    animationController.dispose();
    searchKeyworkNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Favourite page build called');
    ref.listen<AsyncValue<List<FavItemModalClass>>>(favStreamProvider, (
      _,
      next,
    ) {
      next.whenData((data) {
        ref.read(searchListProvider.notifier).updateOriginalList(data);
      });
      if (!next.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          animationController.forward();
        });
      }
    });
    return Scaffold(
      body: Scrollbar(
        radius: Radius.circular(20),
        thickness: 5,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverappbarWithTextField(
              searchKeyword: searchKeyworkNotifier,
              controller: controller,
              focusNode: focusNode,
              isForSearchPage: false,
              isBottomNaviSearchPage: true,
            ),
            SliverSafeArea(
              top: false,
              bottom: false,
              sliver: ValueListenableBuilder(
                valueListenable: searchKeyworkNotifier,
                builder: (context, value, child) {
                  if (value.isNotEmpty) {
                    return SliverPadding(
                      padding: EdgeInsetsGeometry.only(left: 10),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Text('Search result: '),
                            Expanded(
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                value,
                                style: TextStyle(
                                  color: Colors.indigo,
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
                builder: (context, ref, child) {
                  var myRef = ref.watch(favStreamProvider);

                  return myRef.when(
                    data: (data) {
                      var searchRef = ref.watch(searchListProvider);
                      return _myCardWidget(searchRef, scale);
                    },
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => _loading(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myCardWidget(List<FavItemModalClass> list, Animation<double> scale) {
    var searchRef = list.reversed.toList();
    if (searchRef.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  ' ${AppLocalizations.of(context)!.noFavouriteItems} ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SliverPadding(
        padding: const EdgeInsetsGeometry.all(5),
        sliver: SliverGrid.builder(
          itemCount: searchRef.length,

          itemBuilder: (context, index) {
            return ScaleTransition(
              scale: scale,
              child: FavCardWidget(favItem: searchRef[index]),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            mainAxisExtent: 290,
          ),
        ),
      );
    }
  }
}

List<String> _loadingList = List.generate(50, (index) {
  return 'Hi there this is my project';
});

Widget _loading() {
  return SliverPadding(
    padding: const EdgeInsets.all(5),
    sliver: SliverGrid.builder(
      itemCount: _loadingList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        mainAxisExtent: 290,
      ),
      itemBuilder: (context, index) {
        return const Skeletonizer(child: FavLoadingWidget());
      },
    ),
  );
}
