import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/Theme%20controller/theme_riverpod.dart';
import 'package:pix_hunt_project/Pages/home%20screens/language%20page/language_page.dart';

class LoginSliverAppbar extends ConsumerWidget {
  const LoginSliverAppbar({super.key, required this.languageNotifier});
  final ValueNotifier<String> languageNotifier;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [
        Consumer(
          builder: (context, themeRef, _) {
            var theme = themeRef.watch(themeProvider);
            return Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: () {
                  ref.read(themeProvider.notifier).toggeled();
                },

                child: AnimatedCrossFade(
                  firstChild: const Icon(Icons.light_mode),
                  secondChild: const Icon(Icons.dark_mode),
                  crossFadeState:
                      (theme.isDark)
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                  duration: const Duration(seconds: 1),
                ),
              ),
            );
          },
        ),
        IconButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pushNamed(LanguagePage.pageName, arguments: languageNotifier);
          },
          icon: const Icon(Icons.language),
        ),
      ],
    );
  }
}
