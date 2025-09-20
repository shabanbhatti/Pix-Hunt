import 'package:flutter/material.dart';
import 'package:pix_hunt_project/Pages/Home%20Page/home.dart';
import 'package:pix_hunt_project/Pages/Login%20Page/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DecidePage extends StatefulWidget {
  const DecidePage({super.key});
  static const pageName = '/decide_page';
  @override
  State<DecidePage> createState() => _DecidePageState();
}

class _DecidePageState extends State<DecidePage> {
  @override
  void initState() {
    super.initState();

    decide();
  }

  void decide() async {
    var sp = await SharedPreferences.getInstance();

    var isLogged = sp.getBool('logged') ?? false;

    if (isLogged && mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(Home.pageName, (route) => false);
    } else {
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(LoginPage.pageName, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
