import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Pages/Decide%20Page/decide_page.dart';
import 'package:pix_hunt_project/Utils/constant_mgs.dart';

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

    Future.delayed(
      const Duration(milliseconds: 300),
      () => animationController.forward().then(
        (value) => animationControllerForText.forward().then((value) {
          ref.read(loadingProvider.notifier).toggled().then((value) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(DecidePage.pageName, (route) => false,);
              }
            });
          });
        }),
      ),
    );
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              LayoutBuilder(
                builder: (context, constraints) {
                  var mqSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  return ScaleTransition(
                    scale: scale,
                    child: RotationTransition(
                      turns: rotation,
                      child: Hero(
                        tag: 'into_to_login',
                        flightShuttleBuilder:
                            (
                              flightContext,
                              animation,
                              flightDirection,
                              fromHeroContext,
                              toHeroContext,
                            ) => RotationTransition(
                              turns: animation.drive(
                                Tween(begin: 0.0, end: 2 * pi),
                              ),
                              child: toHeroContext.widget,
                            ),
                        child: Image.asset(
                          app_logo,
                          width: mqSize.width * 0.3,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(20),
                child: FadeTransition(
                  opacity: fade,
                  child: const Text(
                    'PIX hunt',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 150),
              Consumer(
                builder: (context, ref, child) {
                  var isLoading = ref.watch(loadingProvider);
                  if (isLoading) {
                    return const CupertinoActivityIndicator(radius: 17);
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------RIVERPOD PORTION------------------

final loadingProvider = StateNotifierProvider<LoadingStateNotifier, bool>((
  ref,
) {
  return LoadingStateNotifier();
});

class LoadingStateNotifier extends StateNotifier<bool> {
  LoadingStateNotifier() : super(false);

  Future<void> toggled() async {
    state = true;
  }
}
