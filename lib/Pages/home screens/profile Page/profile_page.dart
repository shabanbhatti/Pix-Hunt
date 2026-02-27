import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/ads%20controller/banner_ads_controller.dart';
import 'package:pix_hunt_project/Controllers/auth%20controller/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20controller/auth_state.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20controller/user_db_riverpod.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/Widgets/bottom_thanks_widget.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/Widgets/circle_avatar.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/Widgets/profile_listtile_widget.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/Widgets/profile_sliver_appbar.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/constants/constants_sharedPref_keys.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/core/services/shared_preference_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});
  static const pageName = '/user_profile';

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale;
  late Animation<double> fade;
  ValueNotifier<String> usernameNotifier = ValueNotifier('');
  ValueNotifier<String> languageNotifier = ValueNotifier('en');
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack),
    );
    fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward();
      ref.read(bannerAdsProvider.notifier).initBannerAds();
    });

    loadUsername();
    getCurrentLanguage();
  }

  Future<void> loadUsername() async {
    var spService = getIt<SharedPreferencesService>();
    var name = await spService.getString(ConstantsSharedprefKeys.usernameKey);
    await ref.read(userDbProvider.notifier).fetchUserDbData();
    await ref.read(userDbProvider.notifier).onLogin();
    // ref.read(authProvider(AuthKeys.login).notifier).onLogin();
    usernameNotifier.value = name ?? '';
  }

  void getCurrentLanguage() async {
    var sharedPreferencesService = getIt<SharedPreferencesService>();
    var language =
        await sharedPreferencesService.getString(
          ConstantsSharedprefKeys.languageKey,
        ) ??
        'en';
    languageNotifier.value = language;
  }

  @override
  void dispose() {
    animationController.dispose();
    // usernameNotifier.dispose();
    languageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Profile page build called');
    ref.listen(authProvider(AuthKeys.logout), (previous, next) {
      if (next is AuthError) {
        var error = next.error;

        ToastUtils.showToast(error, color: Colors.red);
      } else if (next is AuthLoadedSuccessfuly) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(LoginPage.pageName, (route) => false);
      }
    });
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
    return Scaffold(
      body: RefreshIndicator(
        color: ConstantColors.appColor,
        onRefresh: () {
          return loadUsername();
        },
        child: CustomScrollView(
          slivers: [
            const ProfileSliverAppbar(),
            SliverSafeArea(
              top: false,
              bottom: false,
              sliver: SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const CircleAvatarWidget(),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsGeometry.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadeTransition(
                                  opacity: fade,
                                  child: ScaleTransition(
                                    scale: scale,
                                    child: _userName(),
                                  ),
                                ),

                                FadeTransition(
                                  opacity: fade,
                                  child: ScaleTransition(
                                    scale: scale,
                                    child: _userEmail(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsetsGeometry.only(top: 10)),
            SliverPadding(
              padding: const EdgeInsetsGeometry.symmetric(vertical: 25),
              sliver: SliverSafeArea(
                top: false,
                bottom: false,
                sliver: SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: fade,
                    child: ScaleTransition(
                      scale: scale,
                      child: ProfileListtileWidget(
                        languageNotifier: languageNotifier,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverSafeArea(
              top: false,
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ValueListenableBuilder(
                    valueListenable: usernameNotifier,
                    builder: (context, value, child) {
                      return FadeTransition(
                        opacity: fade,
                        child: ScaleTransition(
                          scale: scale,
                          child: BottomThanksWidget(value: value),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _userName() {
  return Padding(
    padding: EdgeInsets.only(top: 15),
    child: Consumer(
      builder: (context, ref, child) {
        var myRef = ref.watch(userDbProvider);
        if (myRef is LoadingUserDb) {
          return const Skeletonizer(
            child: Text(
              'Muhammad SHaban abubakkar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        } else if (myRef is LoadedSuccessfulyUserDb) {
          return Text(
            myRef.auth.name!,
            maxLines: 2,

            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          );
        } else {
          return const Text('');
        }
      },
    ),
  );
}

Widget _userEmail() {
  return Padding(
    padding: EdgeInsets.only(bottom: 20),
    child: Consumer(
      builder: (context, ref, child) {
        var myRef = ref.watch(userDbProvider);
        if (myRef is LoadingUserDb) {
          return const Skeletonizer(
            enabled: true,
            child: Text(
              'muhammadshabanbhatti@gmail.com',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        } else if (myRef is LoadedSuccessfulyUserDb) {
          return Text(
            myRef.auth.email!,
            maxLines: 2,
            // overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 136, 136, 136),
            ),
          );
        } else {
          return Text('');
        }
      },
    ),
  );
}
