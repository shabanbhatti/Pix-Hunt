import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Pages/Download%20History%20Page/downloads_history_page.dart';
import 'package:pix_hunt_project/Pages/Favourite%20Page/fav_page.dart';
import 'package:pix_hunt_project/Pages/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/Pages/Theme%20page/theme_page.dart';
import 'package:pix_hunt_project/Pages/profile%20Page/Widgets/circle_avatar.dart';
import 'package:pix_hunt_project/Pages/profile%20Page/Widgets/list_tile.dart';
import 'package:pix_hunt_project/Pages/View%20Search%20history%20page/search_history_page.dart';
import 'package:pix_hunt_project/Pages/update%20email%20page/update_email_page.dart';
import 'package:pix_hunt_project/Pages/update%20name%20page/update_name_page.dart';
import 'package:pix_hunt_project/Utils/extensions.dart';
import 'package:pix_hunt_project/Widgets/custom_dialog_boxes.dart';
import 'package:pix_hunt_project/Widgets/custom_sliver_appbar.dart';
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
  ValueNotifier<String> usernameNotifier = ValueNotifier('');
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.bounceOut),
    );

    animationController.forward();
    Future.microtask(() {
      ref.read(userDbProvider.notifier).fetchUserDbData();
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
        onRefresh: () {
          return loadUsername();
        },
        child: CustomScrollView(
          slivers: [
            CustomSliverAppBar(title: 'Profile'),
            SliverSafeArea(
              top: false,
              bottom: false,
              sliver: SliverToBoxAdapter(
                child: ScaleTransition(
                  scale: scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: const CircleAvatarWidget(),
                      ),
                      _userName(),

                      _userEmail(),

                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),

            SliverSafeArea(
              top: false,
              bottom: false,
              sliver: SliverToBoxAdapter(
                child: ScaleTransition(
                  scale: scale,
                  child: Column(
                    children: [
                      DrawerListTile(
                        leading: CupertinoIcons.heart_fill,
                        title: 'Favourites',
                        onTap: () {
                          Navigator.of(context).pushNamed(FavPage.pageName);
                        },
                      ),
                      DrawerListTile(
                        leading: Icons.search,
                        title: 'Search history',
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(ViewSearchHistoryPage.pageName);
                        },
                      ),

                      DrawerListTile(
                        leading: Icons.download,
                        title: 'Download history',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            DownloadHistoryPage.pageName,
                          );
                        },
                      ),
                      DrawerListTile(
                        leading: Icons.light_mode,
                        title: 'Theme',
                        onTap: () {
                          Navigator.of(context).pushNamed(ThemePage.pageName);
                        },
                      ),

                      DrawerListTile(
                        leading: Icons.email,
                        title: 'Update email',
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(UpdateEmailPage.pageName);
                        },
                      ),
                      DrawerListTile(
                        leading: Icons.person,
                        title: 'Update name',
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(UpdateNamePage.pageName);
                        },
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          return DrawerListTile(
                            leading: Icons.logout,
                            title: 'Log out',
                            onTap: () async {
                              showLogoutDialog(context, () async {
                                await ref
                                    .read(authProvider('logout1').notifier)
                                    .logout();
                              });
                            },
                          );
                        },
                      ),
                    ],
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
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '🎉Thanks ',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              value.firstTwoWords(),
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const Text(
                              ' for vising🎉',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
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
