import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/APi%20Riverpod/api_riverpod.dart';
import 'package:pix_hunt_project/Controllers/on%20sync%20after%20email%20verify%20riverpod/on_sync_after_email_verify.dart';
import 'package:pix_hunt_project/Models/pexer.dart';
import 'package:pix_hunt_project/Pages/Search%20page/Widgets/search_photos_pages_widget.dart';
import 'package:pix_hunt_project/Widgets/card_widget.dart';
import 'package:pix_hunt_project/Widgets/loading_card_widget.dart';
import 'package:pix_hunt_project/Widgets/sliverappbar_with_textfield.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key, this.isBottomNaviSearchPage = false});
  static const pageName = '/search_page';
  final bool isBottomNaviSearchPage;

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {

        ref.read(onSyncAfterEmailVerifyProvider.notifier).syncEmailAfterVerification();
      ref.read(apiProvider.notifier).eraseAll();
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('SEARCH PAGE INIT CALLED');
   
    return Scaffold(
      body: Center(
        child: Scrollbar(
          radius: Radius.circular(20),
          thickness: 5,
          child: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverappbarWithTextField(
                controller: controller,
                focusNode: focusNode,
                isBottomNaviSearchPage: widget.isBottomNaviSearchPage,
              ),

              SliverToBoxAdapter(
                child: Center(
                  child: Consumer(
                    builder: (context, apiProviderRef, child) {
                      var myRef = apiProviderRef.watch(apiProvider);
                      switch (myRef) {
                        case ApiLoading():
                          return _loading();
                        case ApiLoadedSuccessfuly(pexer: var pexer):
                          return _widget(pexer);
                        case ApiError(message: var error):
                          return Padding(
                            padding: EdgeInsets.only(top: 300),
                            child: Text(
                              error,
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        default:
                          return _noSearchYet();
                      }
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

  Widget _widget(Pexer pexer) {
    return Column(
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pexer.photos.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 270,
          ),
          itemBuilder: (context, index) {
            return CardWidget(photo: pexer.photos[index], index: index);
          },
        ),
        SearchPhotosPagesWidget(
          controller: controller,
          scrollController: scrollController,
          pexer: pexer,
        ),
      ],
    );
  }
}

Widget _noSearchYet() {
  return Padding(
    padding: EdgeInsets.only(top: 300),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search, size: 30, color: Colors.indigo),
        Padding(
          padding: EdgeInsets.all(5),
          child: const Text(
            'Search content here',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
        ),
      ],
    ),
  );
}

List list = List.generate(50, (index) => index);
Widget _loading() {
  return Skeletonizer(
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 270,
      ),
      itemBuilder: (context, index) {
        return LoadingWidget();
      },
    ),
  );
}
