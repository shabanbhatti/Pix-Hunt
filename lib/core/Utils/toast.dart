import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';

abstract class ToastUtils {
  static void showToast(String message, {Color? color, int? duration}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color ?? ConstantColors.appColor,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: duration ?? 3,
    );
  }
}
