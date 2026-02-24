import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';

import 'package:pix_hunt_project/core/constants/constant_imgs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.scaleIntroIcon,
    required this.fadeIntroIcon,
    required this.scaleIntroText,
    required this.fadeIntroText,
  });
  static const pageName = '/splash_page';
  final Animation<double> scaleIntroIcon;
  final Animation<double> fadeIntroIcon;
  final Animation<double> scaleIntroText;
  final Animation<double> fadeIntroText;

  @override
  State<SplashScreen> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    log('Splash page build called');
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Hero(
                      tag: 'into_to_login',

                      child: ScaleTransition(
                        scale: widget.scaleIntroIcon,
                        child: FadeTransition(
                          opacity: widget.fadeIntroIcon,
                          child: Image.asset(
                            ConstantImgs.app_logo,
                            fit: BoxFit.fitHeight,
                            height: 200,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const SpinKitSquareCircle(
                      size: 30,
                      color: ConstantColors.appColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
