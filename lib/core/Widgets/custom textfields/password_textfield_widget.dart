import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';

class CustomPasswordTextFieldWidget extends StatelessWidget {
  const CustomPasswordTextFieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    this.validator,
    required this.isObscure,
    required this.onFieldSubmitted,
    required this.label,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueNotifier<bool> isObscure;
  final String label;
  final OnSubmitted onFieldSubmitted;
  final OnValidator validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.transparent,

      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: isObscure,
            builder: (context, value, child) {
              return TextFormField(
                controller: controller,
                obscureText: value,
                validator: validator,
                onFieldSubmitted: onFieldSubmitted,
                focusNode: focusNode,
                decoration: InputDecoration(
                  suffixIcon:
                      (value)
                          ? IconButton(
                            onPressed: () {
                              isObscure.value = false;
                            },
                            icon: const Icon(Icons.visibility),
                          )
                          : IconButton(
                            onPressed: () {
                              isObscure.value = true;
                            },
                            icon: const Icon(Icons.visibility_off),
                          ),

                  label: Text(label),
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ConstantColors.appColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
