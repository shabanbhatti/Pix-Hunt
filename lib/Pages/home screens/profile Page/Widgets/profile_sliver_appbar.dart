import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Controllers/language%20riverpod/language_riverpod.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/Widgets/circle_avatar.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
        itemBuilder:
            (context) => const [
              PopupMenuItem(value: 'en', child: Text('🇺🇸 English')),
              PopupMenuItem(value: 'es', child: Text('🇪🇸 Spanish')),
              PopupMenuItem(value: 'ar', child: Text('🇸🇦 Arabic')),
              PopupMenuItem(value: 'ur', child: Text('🇵🇰 Urdu')),
              PopupMenuItem(value: 'zh', child: Text('🇨🇳 Chinese')),
            ],
      ),
    );
  }
}
