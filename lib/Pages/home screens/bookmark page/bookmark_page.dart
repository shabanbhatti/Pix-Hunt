import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/bookmark%20stream%20controller/bookmark_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20controller/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Pages/home%20screens/bookmark%20page/Widgets/bookmark_card_widget.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/Widgets/loading%20widgets/custom_loading_card_widget.dart';
import 'package:pix_hunt_project/core/Widgets/sliverappbar_with_textfield.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/errors/failures/failures.dart';
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

  ValueNotifier<String> searchKeyworkNotifier = ValueNotifier('');

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    controller.addListener(() {
      ref.read(searchListProvider.notifier).search(controller.text);
    });
  }

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

    ref.listen<AsyncValue<List<Photos>>>(bookmarkStreamProvider, (_, next) {
      next.whenData((data) {
        ref.read(searchListProvider.notifier).updateOriginalList(data);
      });

      if (!next.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          animationController.forward(from: 0);
        });
      }
    });

    return Scaffold(
      body: Scrollbar(
        radius: const Radius.circular(20),
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
                      padding: const EdgeInsets.only(left: 10),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: [
                            const Text('Search result: '),
                            Expanded(
                              child: Text(
                                value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                      return _animatedGrid(searchRef);
                    },
                    error: (error, stackTrace) {
                      var message = error as Failures;
                      return SliverFillRemaining(
                        child: Center(child: Text(message.message)),
                      );
                    },
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

  Widget _animatedGrid(List<Photos> list) {
    if (list.isEmpty) {
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
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(5),
      sliver: SliverGrid.builder(
        itemCount: list.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          mainAxisExtent: 290,
        ),
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
                child: BookmarkCardWidget(photos: list[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

List<String> _loadingList = List.generate(50, (index) {
  return 'loading';
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
