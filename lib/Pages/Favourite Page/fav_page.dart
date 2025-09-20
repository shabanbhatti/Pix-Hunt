import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/Fav%20page%20Stream%20riverpod/fav_riverpod.dart';
import 'package:pix_hunt_project/Models/fav_items.dart';
import 'package:pix_hunt_project/Pages/Favourite%20Page/Widgets/fav_card_widget.dart';
import 'package:pix_hunt_project/Pages/Favourite%20Page/Widgets/fav_loading_widget.dart';
import 'package:pix_hunt_project/Widgets/sliverappbar_with_textfield.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavPage extends ConsumerStatefulWidget {
  const FavPage({super.key});
  static const pageName = '/fav_page';

  @override
  ConsumerState<FavPage> createState() => _FavPageState();
}

class _FavPageState extends ConsumerState<FavPage> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      ref.read(searchListProvider.notifier).search(controller.text);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('FAV PAGE BUILD CALLED');
    ref.listen<AsyncValue<List<FavItemModalClass>>>(favStreamProvider, (
      _,
      next,
    ) {
      next.whenData((data) {
        ref.read(searchListProvider.notifier).updateOriginalList(data);
      });
    });
    return Scaffold(
      body: Scrollbar(
        radius: Radius.circular(20),
        thickness: 5,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverappbarWithTextField(
              controller: controller,
              focusNode: focusNode,
              isBottomNaviSearchPage: false,
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Consumer(
                  builder: (context, ref, child) {
                    var myRef = ref.watch(favStreamProvider);
                    print(myRef.value);
                    return myRef.when(
                      data: (data) {
                        var searchRef = ref.watch(searchListProvider);
                        return _myCardWidget(searchRef);
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => _loading(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myCardWidget(List<FavItemModalClass> searchRef) {
    return Padding(
      padding: EdgeInsets.all(5),
      child:
          (searchRef.isEmpty)
              ? Padding(
                padding: EdgeInsets.only(top: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite, color: Colors.indigo),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: const Text(
                        'No Favourite items',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
              : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searchRef.length,
                
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return FavCardWidget(favItem: searchRef[index]);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  mainAxisExtent: 290,
                ),
              ),
    );
  }
}

List<String> _loadingList = List.generate(50, (index) {
  return 'Hi there this is my project';
});

Widget _loading() {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Skeletonizer(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: _loadingList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          mainAxisExtent: 290,
        ),
        itemBuilder: (context, index) {
          return FavLoadingWidget();
        },
      ),
    ),
  );
}
