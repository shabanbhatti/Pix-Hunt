import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20controller/auth_riverpod.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Download%20History%20Page/downloads_history_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/bookmark%20page/bookmark_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Theme%20page/theme_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20Search%20history%20page/search_history_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/language%20page/language_page.dart';
import 'package:pix_hunt_project/core/Utils/get_language_by_code_util.dart';
import 'package:pix_hunt_project/core/Widgets/custom_listtile_widget.dart';
import 'package:pix_hunt_project/core/Utils/dialog%20boxes/logout_dialog_box.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ProfileListtileWidget extends StatelessWidget {
  const ProfileListtileWidget({super.key, required this.languageNotifier});
  final ValueNotifier<String> languageNotifier;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(
          builder: (contextz) {
            return CustomListTileWidget(
              leading: CupertinoIcons.bookmark_fill,
              title: AppLocalizations.of(contextz)!.bookmark,
              onTap: () {
                Navigator.of(context).pushNamed(BookmarkPage.pageName);
              },
            );
          },
        ),
        CustomListTileWidget(
          leading: Icons.search,
          title: AppLocalizations.of(context)!.searchHistory,
          onTap: () {
            Navigator.of(context).pushNamed(ViewSearchHistoryPage.pageName);
          },
        ),

        CustomListTileWidget(
          leading: Icons.download,
          title: AppLocalizations.of(context)!.downloadHistory,
          onTap: () {
            Navigator.pushNamed(context, DownloadHistoryPage.pageName);
          },
        ),
        CustomListTileWidget(
          leading: Icons.light_mode,
          title: AppLocalizations.of(context)!.theme,
          onTap: () {
            Navigator.of(context).pushNamed(ThemePage.pageName);
          },
        ),

        ListTile(
          onTap: () {
            Navigator.of(
              context,
            ).pushNamed(LanguagePage.pageName, arguments: languageNotifier);
          },
          leading: const CircleAvatar(
            backgroundColor: ConstantColors.appColor,
            child: const Icon(Icons.language, color: Colors.white),
          ),
          title: Text(AppLocalizations.of(context)!.language),

          trailing: ValueListenableBuilder(
            valueListenable: languageNotifier,
            builder: (context, value, child) {
              return Text(
                '${getFlagFromCode(value)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),

        Consumer(
          builder: (contextx, ref, child) {
            return CustomListTileWidget(
              leading: CupertinoIcons.square_arrow_right,
              color: Colors.red,
              title: AppLocalizations.of(contextx)!.logout,
              onTap: () async {
                showLogoutDialog(contextx, () async {
                  await ref
                      .read(authProvider(AuthKeys.logout).notifier)
                      .logout();
                });
              },
            );
          },
        ),
      ],
    );
  }
}
