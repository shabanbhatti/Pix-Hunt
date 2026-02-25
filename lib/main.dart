import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pix_hunt_project/Controllers/Theme%20controller/theme_riverpod.dart';
import 'package:pix_hunt_project/Controllers/language%20controller/language_riverpod.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/decide%20page/decide_page.dart';
import 'package:pix_hunt_project/core/Utils/internet_checker_util.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';
import 'package:pix_hunt_project/routes/ogr.dart';
import 'package:pix_hunt_project/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await dotenv.load(fileName: ".env");
  await initGetIt();

  var internetChecker = getIt<InternetCheckerUtil>();
  await internetChecker.checkInternet();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase init error: $e');
  }

  ProviderContainer ref = ProviderContainer();
  await ref.read(themeProvider.notifier).getTheme();
  await ref.read(languageProvider.notifier).getLanguage();

  runApp(UncontrolledProviderScope(container: ref, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var localCode = ref.watch(languageProvider);
    log(localCode);
    return MaterialApp(
      builder: EasyLoading.init(),
      theme: ref.watch(themeProvider).themeData,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerateRoute,
      initialRoute: DecidePage.pageName,

      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ur'),
        Locale('ar'),
        Locale('es'),
        Locale('zh', 'CN'),
      ],
      locale: Locale(ref.watch(languageProvider)),
    );
  }
}
