import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/Theme%20riverpod/theme_riverpod.dart';
import 'package:pix_hunt_project/Controllers/language%20riverpod/language_riverpod.dart';

class LoginSliverAppbar extends ConsumerWidget {
  const LoginSliverAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [
        Consumer(
          builder: (context, themeRef, _) {
            var theme = themeRef.watch(themeProvider);
            return GestureDetector(
              onTap: () {
                ref.read(themeProvider.notifier).toggeled();
              },
              child:
                  (theme.isDark)
                      ? Icon(Icons.light_mode)
                      : Icon(Icons.dark_mode),
            );
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value.isNotEmpty) {
              ref.read(languageProvider.notifier).languageToggled(value);
            }
          },
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
      ],
    );
  }
}
