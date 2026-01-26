import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class ToastUtils {
  static void showToast(String message, {Color? color, int? duration}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color ?? Colors.green,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: duration ?? 3,
    );
  }
}
