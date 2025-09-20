import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pix_hunt_project/Models/dowloads_items_model.dart';
import 'package:pix_hunt_project/Models/fav_items.dart';
import 'package:pix_hunt_project/Models/pexer.dart';
import 'package:pix_hunt_project/Pages/Decide%20Page/decide_page.dart';
import 'package:pix_hunt_project/Pages/Download%20History%20Page/downloads_history_page.dart';
import 'package:pix_hunt_project/Pages/Favourite%20Page/fav_page.dart';
import 'package:pix_hunt_project/Pages/Forgot%20Password%20Page/forget_pass.dart';
import 'package:pix_hunt_project/Pages/Home%20Page/home.dart';
import 'package:pix_hunt_project/Pages/Intro%20Page/intro_page.dart';
import 'package:pix_hunt_project/Pages/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/Pages/Search%20page/search_page.dart';
import 'package:pix_hunt_project/Pages/Signup%20Page/signup_page.dart';
import 'package:pix_hunt_project/Pages/Theme%20page/theme_page.dart';
import 'package:pix_hunt_project/Pages/update%20email%20page/update_email_page.dart';
import 'package:pix_hunt_project/Pages/User%20Profile%20Page/user_profile.dart';
import 'package:pix_hunt_project/Pages/View%20Downloaded%20Item%20page/view_downloaded_item.dart';
import 'package:pix_hunt_project/Pages/View%20Image%20Page%20(FAVOURITE)/view_fav_img_page.dart';
import 'package:pix_hunt_project/Pages/View%20Image%20Page%20(HOME)/view_image_page.dart';
import 'package:pix_hunt_project/Pages/View%20Search%20history%20page/search_history_page.dart';
import 'package:pix_hunt_project/Pages/View%20User%20Image%20page/view_user_img_page.dart';
import 'package:pix_hunt_project/Pages/View%20card%20detail%20page%20(FAVOURITE)/view_fav_detail_card_page.dart';
import 'package:pix_hunt_project/Pages/View%20card%20detail%20page%20(HOME)/view_detail_card_page.dart';
import 'package:pix_hunt_project/Pages/View%20home%20cetagory%20Page/view_page.dart';
import 'package:pix_hunt_project/Pages/update%20name%20page/update_name_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case IntroPage.pageName:
      return MaterialPageRoute(
        builder: (context) => const IntroPage(),
        settings: routeSettings,
      );

    case DecidePage.pageName:
      return MaterialPageRoute(
        builder: (context) => const DecidePage(),
        settings: routeSettings,
      );

       case ForgetPassPage.pageName:
      return MaterialPageRoute(
        builder: (context) => const ForgetPassPage(),
        settings: routeSettings,
      );

    case SignupPage.pageName:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const SignupPage();
        },
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 700),
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
        builder:
            (context){
              var data= routeSettings.arguments as Map<String, dynamic>;
var imgUrl= data['imgUrl'];
var imgPath= data['imgPath'];
              return ViewUserImgPage(imgPath: imgPath,imgUrl: imgUrl, );
            },
                
        settings: routeSettings,
      );

    case ThemePage.pageName:
      return MaterialPageRoute(
        builder: (context) => const ThemePage(),
        settings: routeSettings,
      );

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
      return AnimatedRouting(
        child: ViewContentPage(
          constListProducts:
              routeSettings.arguments as ({String title, String imgPath}),
        ),
        routeSettings: routeSettings,
      );
    case ViewCardPage.pageName:
      return AnimatedRouting(
        child: ViewCardPage(photo: routeSettings.arguments as Photo),
        routeSettings: routeSettings,
      );

    case ViewFavDetailPage.pageName:
      return AnimatedRouting(
        child: ViewFavDetailPage(
          favItemModalClass: routeSettings.arguments as FavItemModalClass,
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
      return CupertinoPageRoute(
        builder: (context) {
          var argument = routeSettings.arguments as Map<String, dynamic>;
          Photo photo = argument['object'] as Photo;
          int index = argument['index'] as int;
          return ViewImagePage(photo: photo, index: index);
        },
      );

    case ViewFavImagePage.pageName:
      return CupertinoPageRoute(
        builder: (context) {
          var data = routeSettings.arguments as Map<String, dynamic>;
          var favItemModalClass = data['object'] as FavItemModalClass;
          var index = data['index'] as int;
          return ViewFavImagePage(
            favItemModalClass: favItemModalClass,
            index: index,
          );
        },
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
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation.drive(Tween(begin: 0.0, end: 1.0)),
              child: child,
            ),
      );
}
