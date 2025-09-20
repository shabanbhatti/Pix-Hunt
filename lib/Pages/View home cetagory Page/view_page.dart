import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/APi%20Riverpod/api_riverpod.dart';

import 'package:pix_hunt_project/Models/pexer.dart';
import 'package:pix_hunt_project/Pages/View%20home%20cetagory%20Page/Widgets/photo_pages_widget.dart';
import 'package:pix_hunt_project/Widgets/card_widget.dart';
import 'package:pix_hunt_project/Widgets/custom_sliver_appbar.dart';
import 'package:pix_hunt_project/Widgets/loading_card_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewContentPage extends ConsumerStatefulWidget {
  const ViewContentPage({super.key, required this.constListProducts});
  static const pageName = '/view_content';

  final ({String title, String imgPath}) constListProducts;
  @override
  ConsumerState<ViewContentPage> createState() => _ViewContentPageState();
}

class _ViewContentPageState extends ConsumerState<ViewContentPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(apiProvider.notifier)
          .fetchApi(search: widget.constListProducts.title, pageNumber: 1);
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('VIEW CONTENT PAGE CALLED');
    return Scaffold(
      body: Center(
        child: Scrollbar(
          controller: scrollController,
          radius: Radius.circular(20),
          thickness: 5,
          child: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              CustomSliverAppBar(title: widget.constListProducts.title),
              SliverToBoxAdapter(
                child: Center(
                  child: Consumer(
                    builder: (context, apiRef, child) {
                      var myRef = apiRef.watch(apiProvider);
                      return switch (myRef) {
                        ApiInitial() => Text(''),
                        ApiLoading() => Skeletonizer(child: _loading()),
                        ApiLoadedSuccessfuly(pexer: var pexer) => _cardData(
                          pexer,
                        ),
                        ApiError(message: var error) => Padding(
                          padding: EdgeInsets.only(top: 300),
                          child: Text(
                            error,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                        ApiEmptyState() =>const Text(''),
                      };
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardData(Pexer pexer) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: pexer.photos.length,
            itemBuilder:
                (context, index) =>
                    CardWidget(photo: pexer.photos[index], index: index),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              mainAxisExtent: 290,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: PhotoPagesWidget(
            constListProducts: widget.constListProducts,
            pexer: pexer,
            scrollController: scrollController,
          ),
        ),
      ],
    );
  }
}

List<String> lodingList = List.generate(
  20,
  (index) => 'My Data is here the loading Data. DO you wanna access',
);
Widget _loading() {
  return Padding(
    padding: EdgeInsets.all(5),
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: lodingList.length,
      itemBuilder: (context, index) => const LoadingWidget(),
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
