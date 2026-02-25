import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:pix_hunt_project/Controllers/User%20image%20controller/user_img_riverpod.dart';
import 'package:pix_hunt_project/Controllers/ads%20controller/banner_ads_controller.dart';
import 'package:pix_hunt_project/Controllers/ads%20controller/interstitial_add_controller.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20controller/user_db_riverpod.dart';
import 'package:pix_hunt_project/Controllers/on%20sync%20after%20email%20verify%20riverpod/on_sync_after_email_verify.dart';
import 'package:pix_hunt_project/Pages/home%20screens/bookmark%20page/bookmark_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Home%20Page/Widgets/box_widget.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Home%20Page/Widgets/sliver_appbar.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Search%20page/search_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/profile_page.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/constants/constant_static_products_home_utils.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(onSyncAfterEmailVerifyProvider.notifier)
          .syncEmailAfterVerification();
      ref.read(userDbProvider.notifier).fetchUserDbData();
      ref.read(interstitialAdProvider.notifier).initInterstitialAds();
      ref.read(userImgProvider.notifier).getImage();
      ref.read(bannerAdsProvider.notifier).initBannerAds();
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
        fabColor: ConstantColors.appColor,
        iconColor: Colors.white,
        icon: AnimatedIcons.home_menu,
        body: const _HomeWidget(),

        items: [
          HawkFabMenuItem(
            label: lng?.profile ?? '',
            ontap: () {
              Navigator.of(context).pushNamed(ProfilePage.pageName);
            },
            icon: const Icon(Icons.person, color: Colors.white),
            color: ConstantColors.appColor,
            labelBackgroundColor: ConstantColors.appColor,
            labelColor: Colors.white,
          ),
          HawkFabMenuItem(
            label: lng?.search ?? '',
            ontap: () {
              Navigator.of(context).pushNamed(SearchPage.pageName);
            },
            icon: const Icon(Icons.search, color: Colors.white),
            color: ConstantColors.appColor,
            labelBackgroundColor: ConstantColors.appColor,
            labelColor: Colors.white,
          ),
          HawkFabMenuItem(
            label: lng?.bookmark ?? '',
            ontap: () {
              Navigator.of(context).pushNamed(BookmarkPage.pageName);
            },
            icon: const Icon(Icons.bookmark, color: Colors.white),
            labelBackgroundColor: ConstantColors.appColor,

            labelColor: Colors.white,
            color: ConstantColors.appColor,
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
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
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
            Align(
              alignment: Alignment.bottomLeft,
              child: Consumer(
                builder: (context, ref, child) {
                  var bannerAdState = ref.watch(bannerAdsProvider);
                  if (bannerAdState is LoadedBannerAdsState) {
                    var bannerAdd = bannerAdState.bannerAd;
                    return Padding(
                      padding: EdgeInsetsGeometry.only(left: 2),
                      child: SizedBox(
                        height: bannerAdd.size.height.toDouble(),
                        width: bannerAdd.size.width.toDouble(),
                        child: AdWidget(key: Key('home'), ad: bannerAdd),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _columnList(List<BoxModel> list) {
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

Widget _topRowList(List<BoxModel> list) {
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
