import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Download%20History%20Page/downloads_history_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Favourite%20Page/fav_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Theme%20page/theme_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20Search%20history%20page/search_history_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/Widgets/profile_list_tile.dart';
import 'package:pix_hunt_project/Pages/home%20screens/update%20email%20page/update_email_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/update%20name%20page/update_name_page.dart';
import 'package:pix_hunt_project/core/Widgets/custom_dialog_boxes.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ProfileListtileWidget extends StatelessWidget {
  const ProfileListtileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(
          builder: (contextz) {
            return DrawerListTile(
              leading: CupertinoIcons.heart_fill,
              title: AppLocalizations.of(contextz)!.favourite,
              onTap: () {
                Navigator.of(context).pushNamed(FavPage.pageName);
              },
            );
          },
        ),
        DrawerListTile(
          leading: Icons.search,
          title: AppLocalizations.of(context)!.searchHistory,
          onTap: () {
            Navigator.of(context).pushNamed(ViewSearchHistoryPage.pageName);
          },
        ),

        DrawerListTile(
          leading: Icons.download,
          title: AppLocalizations.of(context)!.downloadHistory,
          onTap: () {
            Navigator.pushNamed(context, DownloadHistoryPage.pageName);
          },
        ),
        DrawerListTile(
          leading: Icons.light_mode,
          title: AppLocalizations.of(context)!.theme,
          onTap: () {
            Navigator.of(context).pushNamed(ThemePage.pageName);
          },
        ),

        DrawerListTile(
          leading: Icons.email,
          title: AppLocalizations.of(context)!.updateEmail,
          onTap: () {
            Navigator.of(context).pushNamed(UpdateEmailPage.pageName);
          },
        ),
        DrawerListTile(
          leading: Icons.person,
          title: AppLocalizations.of(context)!.updateName,
          onTap: () {
            Navigator.of(context).pushNamed(UpdateNamePage.pageName);
          },
        ),
        Consumer(
          builder: (contextx, ref, child) {
            return DrawerListTile(
              leading: Icons.logout,
              title: AppLocalizations.of(contextx)!.logout,
              onTap: () async {
                showLogoutDialog(contextx, () async {
                  await ref.read(authProvider('logout1').notifier).logout();
                });
              },
            );
          },
        ),
      ],
    );
  }
}
