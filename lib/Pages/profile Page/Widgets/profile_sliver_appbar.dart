import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/language%20riverpod/language_riverpod.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ProfileSliverAppbar extends ConsumerWidget {
  const ProfileSliverAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_new_outlined),
      ),
      title: Text(
        AppLocalizations.of(context)!.profile,
        style: const TextStyle(),
      ),
      floating: true,
      snap: true,

      actions: [
        PopupMenuButton<String>(
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
      ],
    );
  }
}
