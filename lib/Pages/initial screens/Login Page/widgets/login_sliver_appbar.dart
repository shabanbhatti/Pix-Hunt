import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/language%20riverpod/language_riverpod.dart';

class LoginSliverAppbar extends ConsumerWidget {
  const LoginSliverAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
