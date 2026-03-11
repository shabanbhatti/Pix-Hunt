import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/Theme%20controller/theme_riverpod.dart';
import 'package:pix_hunt_project/core/Widgets/custom_sliver_appbar.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});
  static const pageName = '/theme';
  @override
  Widget build(BuildContext context) {
    var lng = AppLocalizations.of(context);
    log('Theme page build called');
    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          CustomSliverAppBar(title: lng?.theme ?? ''),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: ConstantColors.appColor,
                  child: const Icon(Icons.dark_mode, color: Colors.white),
                ),
                title: Text(lng?.darkMode ?? ''),
                trailing: Consumer(
                  builder: (context, ref, child) {
                    var value = ref.watch(themeProvider).isDark;
                    return CupertinoSwitch(
                      value: value,
                      onChanged: (value) {
                        ref.read(themeProvider.notifier).toggeled();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final switchProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
