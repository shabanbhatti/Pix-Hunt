import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:pix_hunt_project/Controllers/User_Image_riverpod.dart/user_img_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Controllers/on%20sync%20after%20email%20verify%20riverpod/on_sync_after_email_verify.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Favourite%20Page/fav_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Home%20Page/Widgets/box_widget.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Home%20Page/Widgets/sliver_appbar.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Search%20page/search_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/user_profile.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/constants/constant_static_products_home_utils.dart';
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
    log('Home page build called');
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

    return SafeArea(
      top: false,
      child: HawkFabMenu(
        backgroundColor: Colors.black.withAlpha(100),
        fabColor: Colors.indigo,
        iconColor: Colors.white,
        icon: AnimatedIcons.home_menu,
        body: const _HomeWidget(),

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
    );
  }
}

class _HomeWidget extends StatelessWidget {
  const _HomeWidget();

  @override
  Widget build(BuildContext x) {
    return Scaffold(
      body: Center(
        child: Scrollbar(
          radius: Radius.circular(20),

          child: CustomScrollView(
            slivers: [
              const HomeSliverAppbar(),

              SliverPadding(
                padding: EdgeInsets.only(top: 20),
                sliver: Consumer(
                  builder: (context, r, _) {
                    return _topRowList(
                      ConstantStaticProductsHomeUtils.product1(context),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(child: const Divider()),
              Consumer(
                builder: (context, r, _) {
                  return _topRowList(
                    ConstantStaticProductsHomeUtils.product3(context),
                  );
                },
              ),
              SliverToBoxAdapter(child: const Divider()),

              Consumer(
                builder: (context, r, _) {
                  return _columnList(
                    ConstantStaticProductsHomeUtils.product6(context),
                  );
                },
              ),
              SliverToBoxAdapter(child: const Divider()),
              Consumer(
                builder: (context, r, _) {
                  return _topRowList(
                    ConstantStaticProductsHomeUtils.product5(context),
                  );
                },
              ),
              SliverToBoxAdapter(child: const Divider()),

              Consumer(
                builder: (context, r, _) {
                  return _columnList(
                    ConstantStaticProductsHomeUtils.product4(context),
                  );
                },
              ),
              SliverToBoxAdapter(child: const Divider()),
              Consumer(
                builder: (context, r, _) {
                  return _columnList(
                    ConstantStaticProductsHomeUtils.product2(context),
                  );
                },
              ),
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
