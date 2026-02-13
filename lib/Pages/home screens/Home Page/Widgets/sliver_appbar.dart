import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_state.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Home%20Page/Widgets/circle_avatar_home_widget.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Search%20page/search_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/user_profile.dart';
import 'package:pix_hunt_project/core/Utils/extensions.dart';
import 'package:pix_hunt_project/core/Utils/get_greeting_hours_method.dart';
import 'package:pix_hunt_project/main.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeSliverAppbar extends ConsumerWidget {
  const HomeSliverAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider('logout'), (previous, next) {
      if (next is AuthError) {
        var error = next.error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      } else if (next is AuthLoadedSuccessfuly) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(LoginPage.pageName, (route) => false);
      }
    });
    return SliverAppBar(
      leading: Builder(
        builder:
            (context) => InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(UserProfile.pageName);
              },
              child: const CircleAvatarHomeWidget(),
            ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    navigatorKey.currentContext!,
                    SearchPage.pageName,
                  );
                },
                icon: const Icon(Icons.search, size: 30, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
      backgroundColor: Colors.transparent,
      pinned: true,
      expandedHeight: 200,
      // floating: true,
      // snap: true,
      flexibleSpace: FlexibleSpaceBar(
        background: LayoutBuilder(
          builder: (context, constraints) {
            var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
            return Container(
              width: mqSize.width,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.75,
                    child: Image.asset(
                      'assets/images/wallpaper.jpg',
                      fit: BoxFit.fill,
                      height: mqSize.height,
                      width: mqSize.width,
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-0.8, 0.1),
                    child: Text(
                      getGreetingMessage(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 0.6),
                    child: Consumer(
                      builder: (context, ref, child) {
                        var myRef = ref.watch(userDbProvider);

                        return switch (myRef) {
                          InitialUserDb() => Text(''),
                          LoadingUserDb() => Skeletonizer(
                            enabled: true,
                            child: Text('Loading.....'),
                          ),
                          LoadedSuccessfulyUserDb(auth: var auth) => Text(
                            auth.name!.firstTwoWords(),

                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,

                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black87,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          ErrorUserDb(error: var error) => Text(error),
                        };
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
