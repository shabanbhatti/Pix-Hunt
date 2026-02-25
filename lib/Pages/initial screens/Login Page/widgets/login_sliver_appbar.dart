import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/Theme%20controller/theme_riverpod.dart';
import 'package:pix_hunt_project/Controllers/language%20controller/language_riverpod.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';

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
            return Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  ref.read(themeProvider.notifier).toggeled();
                },
                child:
                    (theme.isDark)
                        ? const Icon(Icons.light_mode)
                        : const Icon(Icons.dark_mode),
              ),
            );
          },
        ),
        PopupMenuButton<String>(
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
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 'es',
                  child: ListTile(
                    leading: Text('🇪🇸', style: TextStyle(fontSize: 20)),
                    title: Text('Spanish'),
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 'ar',
                  child: ListTile(
                    leading: Text('🇸🇦', style: TextStyle(fontSize: 20)),
                    title: Text('Arabic'),
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 'ur',
                  child: ListTile(
                    leading: Text('🇵🇰', style: TextStyle(fontSize: 20)),
                    title: Text('Urdu'),
                  ),
                ),
                PopupMenuDivider(),
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
