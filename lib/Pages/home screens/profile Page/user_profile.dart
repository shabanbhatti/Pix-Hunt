import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_state.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/Widgets/bottom_thanks_widget.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/Widgets/circle_avatar.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/Widgets/profile_listtile_widget.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/Widgets/profile_sliver_appbar.dart';

import 'package:pix_hunt_project/services/shared_preference_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});
  static const pageName = '/user_profile';

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  // late Animation<Offset> slide;
  late Animation<double> scale;
  late Animation<double> fade;
  ValueNotifier<String> usernameNotifier = ValueNotifier('');
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
    });

    loadUsername();
  }

  Future<void> loadUsername() async {
    var name = await SpService.getString('username');
    usernameNotifier.value = name ?? '';
  }

  @override
  void dispose() {
    animationController.dispose();
    usernameNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('DRAWER BUILD CALLED');
    ref.listen(authProvider('logout1'), (previous, next) {
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
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.indigo,
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
                    const Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: const CircleAvatarWidget(),
                    ),
                    FadeTransition(
                      opacity: fade,
                      child: ScaleTransition(scale: scale, child: _userName()),
                    ),

                    FadeTransition(
                      opacity: fade,
                      child: ScaleTransition(scale: scale, child: _userEmail()),
                    ),

                    const Divider(),
                  ],
                ),
              ),
            ),

            SliverSafeArea(
              top: false,
              bottom: false,
              sliver: SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: fade,
                  child: ScaleTransition(
                    scale: scale,
                    child: const ProfileListtileWidget(),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Divider()),
            SliverPadding(
              padding: const EdgeInsetsGeometry.only(top: 20),
              sliver: SliverSafeArea(
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
            ),
          ],
        ),
      ),
    );
  }
}

Widget _userName() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
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
