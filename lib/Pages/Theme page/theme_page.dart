import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/Theme%20riverpod/theme_riverpod.dart';
import 'package:pix_hunt_project/Widgets/custom_app_bar.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});
  static const pageName = '/theme';
  @override
  Widget build(BuildContext context) {
    print('Theme Build CALLED');
    return Scaffold(
      appBar: customAppBar('Theme'),

      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigo,
            child: Icon(Icons.dark_mode, color: Colors.white),
          ),
          title: Text('Dark mode'),
          trailing: Consumer(
            builder: (context, ref, child) {
              var value = ref.watch(themeProvider).isDark;
              return Switch(
                activeThumbColor: Colors.indigo,
                inactiveThumbColor: Colors.grey,

                // focusColor: Colors.red,
                // hoverColor: Colors.red,
                thumbColor: WidgetStatePropertyAll(Colors.indigo),
                activeTrackColor: const Color.fromARGB(255, 237, 237, 237),
                value: value,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggeled();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

final switchProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
