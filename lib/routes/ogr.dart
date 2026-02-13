import 'package:flutter/material.dart';
import 'package:pix_hunt_project/Models/dowloads_items_model.dart';

import 'package:pix_hunt_project/Pages/home%20screens/Download%20History%20Page/downloads_history_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Favourite%20Page/fav_page.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Forgot%20Password%20Page/forget_pass.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Home%20Page/home.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/splash%20page/splash_page.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Search%20page/search_page.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Signup%20Page/signup_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Theme%20page/theme_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20Image%20Page/view_img_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/update%20email%20page/update_email_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/profile%20Page/user_profile.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20Downloaded%20Item%20page/view_downloaded_item.dart';

import 'package:pix_hunt_project/Pages/home%20screens/View%20Search%20history%20page/search_history_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20User%20Image%20page/view_user_img_page.dart';

import 'package:pix_hunt_project/Pages/home%20screens/View%20home%20cetagory%20Page/view_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/update%20name%20page/update_name_page.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/decide%20page/decide_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case DecidePage.pageName:
      return StraightRouting(child: const DecidePage());

    case ForgetPassPage.pageName:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const ForgetPassPage();
        },

        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0, 1), end: Offset.zero),
              ),
              child: child,
            ),
      );

    case SignupPage.pageName:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const SignupPage();
        },

        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0, 1), end: Offset.zero),
              ),
              child: child,
            ),
      );

    case LoginPage.pageName:
      return AnimatedRouting(
        child: const LoginPage(),
        routeSettings: routeSettings,
      );

    case Home.pageName:
      return AnimatedRouting(child: const Home(), routeSettings: routeSettings);
    // const UserProfile()
    case UserProfile.pageName:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const UserProfile();
        },

        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(-1, 0), end: Offset.zero),
              ),
              child: child,
            ),
      );

    case FavPage.pageName:
      return AnimatedRouting(
        child: const FavPage(),
        routeSettings: routeSettings,
      );

    case SearchPage.pageName:
      return AnimatedRouting(
        child: const SearchPage(),
        routeSettings: routeSettings,
      );

    case ViewSearchHistoryPage.pageName:
      return AnimatedRouting(
        child: const ViewSearchHistoryPage(),
        routeSettings: routeSettings,
      );

    case DownloadHistoryPage.pageName:
      return AnimatedRouting(
        child: const DownloadHistoryPage(),
        routeSettings: routeSettings,
      );
    case ViewUserImgPage.pageName:
      return MaterialPageRoute(
        builder: (context) {
          var data = routeSettings.arguments as Map<String, dynamic>;
          var imgUrl = data['imgUrl'];

          return ViewUserImgPage(imgUrl: imgUrl);
        },

        settings: routeSettings,
      );

    case ThemePage.pageName:
      return AnimatedRouting(child: const ThemePage());

    case UpdateEmailPage.pageName:
      return AnimatedRouting(
        child: const UpdateEmailPage(),
        routeSettings: routeSettings,
      );

    case UpdateNamePage.pageName:
      return AnimatedRouting(
        child: const UpdateNamePage(),
        routeSettings: routeSettings,
      );

    case ViewContentPage.pageName:
      var data = routeSettings.arguments as Map<String, dynamic>;
      var record = data['record'] as ({String title, String imgPath})?;
      var title = data['title'] as String;
      return AnimatedRouting(
        child: ViewContentPage(
          constListProducts: record == null ? (imgPath: '', title: '') : record,
          title: title.isEmpty ? null : title,
        ),
        routeSettings: routeSettings,
      );

    case ViewDownloadedItem.pageName:
      return AnimatedRouting(
        child: ViewDownloadedItem(
          downloadsItem: routeSettings.arguments as DownloadsItem,
        ),
        routeSettings: routeSettings,
      );

    case ViewImagePage.pageName:
      return AnimatedRouting(
        child: ViewImagePage(
          imgRecord:
              routeSettings.arguments as ({String imgPath, String pixels}),
        ),
      );

    default:
      return MaterialPageRoute(
        builder:
            (context) => const Scaffold(body: Center(child: Text('ERROR'))),
        settings: routeSettings,
      );
  }
}

class AnimatedRouting extends PageRouteBuilder {
  final Widget child;

  AnimatedRouting({required this.child, RouteSettings? routeSettings})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        settings: routeSettings,
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation.drive(Tween(begin: 0.0, end: 1.0)),
              child: child,
            ),
      );
}

class StraightRouting extends PageRouteBuilder {
  final Widget child;

  StraightRouting({required this.child, RouteSettings? routeSettings})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        settings: routeSettings,
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => ScaleTransition(
              scale: animation.drive(Tween(begin: 1.0, end: 1.0)),
              child: child,
            ),
      );
}
