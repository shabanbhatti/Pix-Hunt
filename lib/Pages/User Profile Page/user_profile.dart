import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Pages/Download%20History%20Page/downloads_history_page.dart';
import 'package:pix_hunt_project/Pages/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/Pages/Theme%20page/theme_page.dart';
import 'package:pix_hunt_project/Pages/User%20Profile%20Page/Widgets/circle_avatar.dart';
import 'package:pix_hunt_project/Pages/User%20Profile%20Page/Widgets/list_tile.dart';
import 'package:pix_hunt_project/Pages/View%20Search%20history%20page/search_history_page.dart';
import 'package:pix_hunt_project/Pages/update%20email%20page/update_email_page.dart';
import 'package:pix_hunt_project/Pages/update%20name%20page/update_name_page.dart';
import 'package:pix_hunt_project/Widgets/custom_app_bar.dart';
import 'package:pix_hunt_project/Widgets/custom_dialog_boxes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});
  static const pageName = '/user_profile';

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userDbProvider.notifier).fetchUserDbData();
    });
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
      appBar: customAppBar('Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: const CircleAvatarWidget(),
              ),
              _userName(),

              _userEmail(),

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
                  Navigator.pushNamed(context, DownloadHistoryPage.pageName);
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
                leading: Icons.update,
                title: 'Update email',
                onTap: () {
                  Navigator.of(context).pushNamed(UpdateEmailPage.pageName);
                },
              ),
              DrawerListTile(
                leading: Icons.update,
                title: 'Update name',
                onTap: () {
                  Navigator.of(context).pushNamed(UpdateNamePage.pageName);
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
          return Skeletonizer(
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          return Skeletonizer(
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
            style: TextStyle(
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
