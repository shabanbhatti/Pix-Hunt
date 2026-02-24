import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';

enum WidgetOrTitle { widget, title }

class AppMainBtn extends StatelessWidget {
  const AppMainBtn({
    super.key,
    required this.onTap,
    this.focusNode,
    required this.widgetOrTitle,
    this.btnValueWidget,
    this.btnTitle,
    this.color,
  });
  final OnPressed onTap;
  final FocusNode? focusNode;
  final WidgetOrTitle widgetOrTitle;
  final Widget? btnValueWidget;
  final String? btnTitle;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        focusNode: focusNode,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? ConstantColors.appColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child:
            (widgetOrTitle == WidgetOrTitle.title)
                ? Text(btnTitle!, style: TextStyle(color: Colors.white))
                : btnValueWidget,
      ),
    );
  }
}
