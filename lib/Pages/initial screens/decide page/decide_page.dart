import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20controller/auth_riverpod.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Home%20Page/home.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Intro%20Page/intro_page.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/splash%20page/splash_page.dart';
import 'package:pix_hunt_project/core/constants/constants_sharedPref_keys.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/core/services/shared_preference_service.dart';

class DecidePage extends ConsumerStatefulWidget {
  const DecidePage({super.key});
  static const String pageName = '/';

  @override
  ConsumerState<DecidePage> createState() => _DecidePageState();
}

class _DecidePageState extends ConsumerState<DecidePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  late Animation<double> desScaleAnimation;
  late Animation<double> desFadeAnimation;

  late Animation<double> btnScaleAnimation;
  late Animation<double> btnFadeAnimation;
  // ---------------------------------
  late Animation<double> scaleIntroIcon;
  late Animation<double> fadeIntroIcon;
  late Animation<double> scaleIntroText;
  late Animation<double> fadeIntroText;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Interval(0.0, 0.3)),
    );

    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 0.3, curve: Curves.bounceOut),
      ),
    );

    desFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Interval(0.3, 0.6)),
    );

    desScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 0.6, curve: Curves.bounceOut),
      ),
    );

    btnFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Interval(0.6, 1.0)),
    );

    btnScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.6, 1.0, curve: Curves.bounceOut),
      ),
    );
    // --------------------------------------------
    scaleIntroIcon = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 0.5, curve: Curves.bounceOut),
      ),
    );
    fadeIntroIcon = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Interval(0.0, 0.5)),
    );

    scaleIntroText = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.bounceOut),
      ),
    );
    fadeIntroText = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Interval(0.5, 1.0)),
    );
    whichPage();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward();
    });
  }

  void loadPage() async {
    var user = await ref.read(authProvider('intro').notifier).isUserNull();

    if (user) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(Home.pageName, (route) => false);
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(LoginPage.pageName, (route) => false);
        }
      });
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  ValueNotifier<bool> isIntroNotifier = ValueNotifier(false);

  void whichPage() async {
    var spService = getIt<SharedPreferencesService>();
    var isIntro = await spService.getBool(ConstantsSharedprefKeys.introPageKey);
    if (isIntro) {
      isIntroNotifier.value = isIntro;
      loadPage();
    } else {
      isIntroNotifier.value = isIntro;
    }
  }

  @override
  Widget build(BuildContext context) {
    log('Decide page build called');
    return ValueListenableBuilder(
      valueListenable: isIntroNotifier,
      builder: (context, value, child) {
        if (value) {
          return SplashScreen(
            fadeIntroIcon: fadeIntroIcon,
            fadeIntroText: fadeIntroText,
            scaleIntroIcon: scaleIntroIcon,
            scaleIntroText: scaleIntroText,
          );
        } else {
          return IntroPage(
            btnFadeAnimation: btnFadeAnimation,
            btnScaleAnimation: btnScaleAnimation,
            desFadeAnimation: desFadeAnimation,
            desScaleAnimation: desScaleAnimation,
            fadeAnimation: fadeAnimation,
            scaleAnimation: scaleAnimation,
          );
        }
      },
    );
  }
}
