import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Pages/Home%20Page/home.dart';
import 'package:pix_hunt_project/Pages/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/Utils/constant_mgs.dart';
import 'package:shimmer/shimmer.dart';

class IntroPage extends ConsumerStatefulWidget {
  const IntroPage({super.key});
  static const pageName = '/';

  @override
  ConsumerState<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController animationControllerForText;
  late Animation<double> rotation;
  late Animation<double> scale;
  late Animation<double> fade;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animationControllerForText = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    rotation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack),
    );
    scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack),
    );
    fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationControllerForText,
        curve: Curves.easeInOutBack,
      ),
    );
    loadAnimation();
  }

  void loadAnimation() async {
    await Future.delayed(const Duration(microseconds: 300), () {
      animationController.forward();
    });
    await Future.delayed(const Duration(), () {
      animationControllerForText.forward();
    });

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
    animationControllerForText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('INTRO BUILD CALLED');
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: scale,
                      child: RotationTransition(
                        turns: rotation,
                        child: Hero(
                          tag: 'into_to_login',

                          child: Image.asset(
                            app_logo,
                            fit: BoxFit.fitWidth,
                            height: 150,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: fade,
                      child: Shimmer.fromColors(
                        baseColor: Theme.of(context).primaryColor,
                        highlightColor: const Color.fromARGB(
                          255,
                          132,
                          132,
                          132,
                        ),
                        period: const Duration(seconds: 1),
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

// ------------RIVERPOD PORTION------------------

// final loadingProvider = StateNotifierProvider<LoadingStateNotifier, bool>((
//   ref,
// ) {
//   return LoadingStateNotifier();
// });

// class LoadingStateNotifier extends StateNotifier<bool> {
//   LoadingStateNotifier() : super(false);

//   Future<void> toggled() async {

//     state = true;
//   }
// }
