import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.prefixIcon,
    required this.onSubmitted,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final IconData prefixIcon;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      onSubmitted: onSubmitted,

      controller: controller,
      focusNode: focusNode,
    );
  }
}
