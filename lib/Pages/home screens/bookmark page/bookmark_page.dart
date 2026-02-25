import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/bookmark%20stream%20controller/bookmark_riverpod.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Pages/home%20screens/bookmark%20page/Widgets/bookmark_card_widget.dart';
import 'package:pix_hunt_project/core/Widgets/loading%20widgets/custom_loading_card_widget.dart';
import 'package:pix_hunt_project/core/Widgets/sliverappbar_with_textfield.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookmarkPage extends ConsumerStatefulWidget {
  const BookmarkPage({super.key});
  static const pageName = '/fav_page';

  @override
  ConsumerState<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarkPage>
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
    scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack),
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
    log('Bookmark page build called');
    ref.listen<AsyncValue<List<Photos>>>(bookmarkStreamProvider, (_, next) {
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
                builder: (context, ref, child) {
                  var myRef = ref.watch(bookmarkStreamProvider);

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

  Widget _myCardWidget(List<Photos> list, Animation<double> scale) {
    var searchRef = list;
    ;
    if (searchRef.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bookmark),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  ' ${AppLocalizations.of(context)!.noBookmarkItems} ',
                  style: const TextStyle(fontWeight: FontWeight.normal),
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
              child: BookmarkCardWidget(photos: searchRef[index]),
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
        return const Skeletonizer(child: CustomLoadingCardsWidget());
      },
    ),
  );
}
