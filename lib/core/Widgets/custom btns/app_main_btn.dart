import 'package:flutter/material.dart';

enum WidgetOrTitle { widget, title }

class AppMainBtn extends StatelessWidget {
  const AppMainBtn({
    super.key,
    required this.onTap,
    this.focusNode,
    required this.widgetOrTitle,
    this.btnValueWidget,
    this.btnTitle,
  });
  final void Function() onTap;
  final FocusNode? focusNode;
  final WidgetOrTitle widgetOrTitle;
  final Widget? btnValueWidget;
  final String? btnTitle;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        focusNode: focusNode,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
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
