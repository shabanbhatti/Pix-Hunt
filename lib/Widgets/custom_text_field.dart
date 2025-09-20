
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.prefixIcon,
    required this.onSubmitted
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
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          controller: controller,
          focusNode: focusNode,

          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 5),
            hintText: 'Search',
            hintStyle: const TextStyle(color: Colors.white),
            prefixIcon: Icon(prefixIcon, color: Colors.white),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),

            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
