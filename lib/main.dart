import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/Theme%20riverpod/theme_riverpod.dart';
import 'package:pix_hunt_project/routes/ogr.dart';
import 'package:pix_hunt_project/firebase_options.dart';

var navigatorKey = GlobalKey<NavigatorState>();
var scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase init error: $e');
  }

  ProviderContainer ref = ProviderContainer();
  await ref.read(themeProvider.notifier).getTheme();

  runApp(UncontrolledProviderScope(container: ref, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ref.watch(themeProvider).themeData,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerateRoute,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
