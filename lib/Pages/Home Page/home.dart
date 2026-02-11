import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:pix_hunt_project/Controllers/User_Image_riverpod.dart/user_img_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Controllers/on%20sync%20after%20email%20verify%20riverpod/on_sync_after_email_verify.dart';
import 'package:pix_hunt_project/Pages/Favourite%20Page/fav_page.dart';
import 'package:pix_hunt_project/Pages/Home%20Page/Widgets/box_widget.dart';
import 'package:pix_hunt_project/Pages/Home%20Page/Widgets/sliver_appbar.dart';
import 'package:pix_hunt_project/Pages/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/Pages/Search%20page/search_page.dart';
import 'package:pix_hunt_project/Pages/profile%20Page/user_profile.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  static const pageName = '/home_page';
  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      ref
          .read(onSyncAfterEmailVerifyProvider.notifier)
          .syncEmailAfterVerification();
      ref.read(userDbProvider.notifier).fetchUserDbData();
      ref.read(userImgProvider.notifier).getImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('HOME BUILD CALLED');
    var lng = AppLocalizations.of(context);
    ref.listen(onSyncAfterEmailVerifyProvider, (previous, next) async {
      var error = next;
      if (error == 'user-token-expired' ||
          error ==
              "[firebase_auth/user-token-expired] The user's credential is no longer valid. The user must sign in again.") {
        ToastUtils.showToast('Email verified! please login with new email');
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(LoginPage.pageName, (route) => false);
      }
    });

    ref.listen(userDbProvider, (previous, next) {
      if (next is ErrorUserDb) {
        var error = next.error;

        ToastUtils.showToast(error, color: Colors.red);
      }
    });

    List<({String title, String imgPath})> products1 = [
      (title: lng?.nature ?? '', imgPath: 'nature.jpg'),
      (title: lng?.flowers ?? '', imgPath: 'flowers.jpg'),
      (title: lng?.forests ?? '', imgPath: 'forests.jpg'),
      (title: lng?.oceans ?? '', imgPath: 'oceans.jpg'),
      (title: lng?.rivers ?? '', imgPath: 'rivers.jpg'),
    ];

    List<({String title, String imgPath})> products2 = [
      (title: lng?.mountains ?? '', imgPath: 'mountains.jpg'),
      (title: lng?.deserts ?? '', imgPath: 'desert.jpg'),
      (title: lng?.night ?? '', imgPath: 'moon.jpg'),
      (title: lng?.waterfall ?? '', imgPath: 'waterfall.jpg'),
    ];

    List<({String title, String imgPath})> products3 = [
      (title: lng?.universe ?? '', imgPath: 'universe.jpg'),
      (title: lng?.city ?? '', imgPath: 'city.jpg'),
      (title: lng?.village ?? '', imgPath: 'village.jpeg'),
      (title: lng?.wildlife ?? '', imgPath: 'wild_life.jpg'),
    ];

    List<({String title, String imgPath})> products4 = [
      (title: lng?.mosque ?? '', imgPath: 'mosque.jpg'),
      (title: lng?.synagogue ?? '', imgPath: 'synagogue.jpg'),
      (title: lng?.church ?? '', imgPath: 'church.jpg'),
    ];

    List<({String title, String imgPath})> products5 = [
      (title: lng?.mysticPlaces ?? '', imgPath: 'mystric.jpg'),
      (title: lng?.historicalPlaces ?? '', imgPath: 'historical.jpg'),
      (title: lng?.animals ?? '', imgPath: 'animals.jpg'),
    ];

    List<({String title, String imgPath})> products6 = [
      (title: lng?.village ?? '', imgPath: 'village.jpeg'),
      (title: lng?.motorcycles ?? '', imgPath: 'motorcycle.jpg'),
      (title: lng?.cars ?? '', imgPath: 'cars.jpg'),

      (title: lng?.animals ?? '', imgPath: 'animals.jpg'),
      (title: lng?.village ?? '', imgPath: 'village.jpeg'),
      (title: lng?.city ?? '', imgPath: 'city.jpg'),
    ];
    return Material(
      child: Padding(
        padding: EdgeInsetsGeometry.only(bottom: 20),
        child: HawkFabMenu(
          backgroundColor: Colors.black.withAlpha(100),
          fabColor: Colors.indigo,
          iconColor: Colors.white,
          icon: AnimatedIcons.home_menu,
          body: _HomeWidget(
            products1: products1,
            products3: products3,
            products6: products6,
            products5: products5,
            products4: products4,
            products2: products2,
          ),

          items: [
            HawkFabMenuItem(
              label: lng?.profile ?? '',
              ontap: () {
                Navigator.of(context).pushNamed(UserProfile.pageName);
              },
              icon: const Icon(Icons.person, color: Colors.white),
              color: Colors.indigo,
              labelBackgroundColor: Colors.indigo,
              labelColor: Colors.white,
            ),
            HawkFabMenuItem(
              label: lng?.search ?? '',
              ontap: () {
                Navigator.of(context).pushNamed(SearchPage.pageName);
              },
              icon: const Icon(Icons.search, color: Colors.white),
              color: Colors.indigo,
              labelBackgroundColor: Colors.indigo,
              labelColor: Colors.white,
            ),
            HawkFabMenuItem(
              label: lng?.favourite ?? '',
              ontap: () {
                Navigator.of(context).pushNamed(FavPage.pageName);
              },
              icon: const Icon(Icons.favorite, color: Colors.white),
              labelBackgroundColor: Colors.indigo,

              labelColor: Colors.white,
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }
}

typedef _RecordList = List<({String imgPath, String title})>;

class _HomeWidget extends StatelessWidget {
  const _HomeWidget({
    required this.products1,
    required this.products3,
    required this.products6,
    required this.products5,
    required this.products4,
    required this.products2,
  });
  final _RecordList products1;
  final _RecordList products3;
  final _RecordList products6;
  final _RecordList products5;
  final _RecordList products4;
  final _RecordList products2;
  @override
  Widget build(BuildContext context) {
    print('LLLL');
    return Scaffold(
      body: Center(
        child: Scrollbar(
          radius: Radius.circular(20),

          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const HomeSliverAppbar(),

              SliverPadding(
                padding: EdgeInsets.only(top: 20),
                sliver: _topRowList(products1),
              ),
              SliverToBoxAdapter(child: const Divider()),
              _topRowList(products3),
              SliverToBoxAdapter(child: const Divider()),

              _columnList(products6),
              SliverToBoxAdapter(child: const Divider()),
              _topRowList(products5),
              SliverToBoxAdapter(child: const Divider()),

              _columnList(products4),
              SliverToBoxAdapter(child: const Divider()),
              _columnList(products2),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _columnList(List<({String title, String imgPath})> list) {
  return SliverPadding(
    padding: const EdgeInsets.all(5),
    sliver: SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => BoxWidget(record: list[index]),
        childCount: list.length,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
    ),
  );
}

Widget _topRowList(List<({String title, String imgPath})> list) {
  return SliverToBoxAdapter(
    child: SizedBox(
      height: 130,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: list.length,

        itemBuilder: (context, index) {
          return BoxWidget(record: list[index]);
        },
      ),
    ),
  );
}
