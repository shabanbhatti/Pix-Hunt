import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Pages/home%20screens/setting%20page/setting_page.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ProfileSliverAppbar extends ConsumerWidget {
  const ProfileSliverAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoSliverNavigationBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios_new_outlined),
      ),
      largeTitle: Text(AppLocalizations.of(context)!.profile),

      trailing: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(SettingPage.pageName);
        },
        child: const Icon(Icons.settings, size: 30),
      ),
    );
  }
}
