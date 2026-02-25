import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/language%20controller/language_riverpod.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
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

      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value.isNotEmpty) {
            ref.read(languageProvider.notifier).languageToggled(value);
          }
        },
        child: const Icon(
          Icons.g_translate_outlined,
          color: ConstantColors.appColor,
        ),

        itemBuilder:
            (context) => const [
              PopupMenuItem(
                value: 'en',
                child: ListTile(
                  leading: Text('🇺🇸', style: TextStyle(fontSize: 20)),
                  title: Text('English'),
                ),
              ),
              PopupMenuItem(
                value: 'es',
                child: ListTile(
                  leading: Text('🇪🇸', style: TextStyle(fontSize: 20)),
                  title: Text('Spanish'),
                ),
              ),
              PopupMenuItem(
                value: 'ar',
                child: ListTile(
                  leading: Text('🇸🇦', style: TextStyle(fontSize: 20)),
                  title: Text('Arabic'),
                ),
              ),
              PopupMenuItem(
                value: 'ur',
                child: ListTile(
                  leading: Text('🇵🇰', style: TextStyle(fontSize: 20)),
                  title: Text('Urdu'),
                ),
              ),
              PopupMenuItem(
                value: 'zh',
                child: ListTile(
                  leading: Text('🇨🇳', style: TextStyle(fontSize: 20)),
                  title: Text('Chinese'),
                ),
              ),
            ],
      ),
    );
  }
}
