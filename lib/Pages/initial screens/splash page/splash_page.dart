import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:pix_hunt_project/core/constants/constant_imgs.dart';
import 'package:shimmer/shimmer.dart';

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
            slivers: [
              SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'into_to_login',

                      child: ScaleTransition(
                        scale: widget.scaleIntroIcon,
                        child: FadeTransition(
                          opacity: widget.fadeIntroIcon,
                          child: Image.asset(
                            app_logo,
                            fit: BoxFit.fitWidth,
                            height: 150,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).primaryColor,
                      highlightColor: const Color.fromARGB(255, 132, 132, 132),
                      period: const Duration(seconds: 1),
                      child: FadeTransition(
                        opacity: widget.fadeIntroText,
                        child: const Text(
                          'PIX hunt',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
