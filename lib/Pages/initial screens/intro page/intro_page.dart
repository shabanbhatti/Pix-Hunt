import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20btns/app_main_btn.dart';
import 'package:pix_hunt_project/core/constants/constant_imgs.dart';
import 'package:pix_hunt_project/core/constants/constants_sharedPref_keys.dart';

import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/core/services/shared_preference_service.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({
    super.key,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.desScaleAnimation,
    required this.desFadeAnimation,
    required this.btnScaleAnimation,
    required this.btnFadeAnimation,
  });
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;

  final Animation<double> desScaleAnimation;
  final Animation<double> desFadeAnimation;

  final Animation<double> btnScaleAnimation;
  final Animation<double> btnFadeAnimation;
  @override
  Widget build(BuildContext context) {
    log('Intro page build called');
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            Opacity(
              opacity: 0.5,
              child: Image.asset(
                ConstantImgs.mountains_back,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: scaleAnimation,
                          child: FadeTransition(
                            opacity: fadeAnimation,
                            child: const Text(
                              '𝒲𝑒𝓁𝒸𝑜𝓂𝑒!',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsetsGeometry.only(top: 10),
                          child: ScaleTransition(
                            scale: desScaleAnimation,
                            child: FadeTransition(
                              opacity: desFadeAnimation,
                              child: const Text(
                                'Press Continue and download ultra HD images completely free on your phone. Enjoy rich, high quality pixels and stunning visuals anytime.🎉',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsetsGeometry.only(top: 50),
                          child: ScaleTransition(
                            scale: btnScaleAnimation,
                            child: FadeTransition(
                              opacity: btnFadeAnimation,
                              child: AppMainBtn(
                                onTap: () async {
                                  var spService = getIt<SharedPreferencesService>();
                                  await spService.setBool(ConstantsSharedprefKeys.introPageKey, true);
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    LoginPage.pageName,
                                    (route) => false,
                                  );
                                },
                                widgetOrTitle: WidgetOrTitle.title,
                                btnTitle: 'Continue →',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
