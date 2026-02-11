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
    return Center(
      child: SizedBox(
        height: 40,
        child: TextField(
          onSubmitted: onSubmitted,

          controller: controller,
          focusNode: focusNode,

          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 5),
            hintText: label,

            prefixIcon: Icon(prefixIcon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
