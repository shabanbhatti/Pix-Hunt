import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';

class InternetCheckerUtil {
  final InternetConnectionChecker internetChecker;
  const InternetCheckerUtil({required this.internetChecker});
  Future<bool> checkInternet({String? message}) async {
    var isConnected = await internetChecker.hasConnection;
    if (!isConnected) {
      ToastUtils.showToast(
        message ?? 'No Internet Connection! Please Check Your Internet',
        color: Colors.red,
        duration: 5,
      );
    }
    return isConnected;
  }
}
