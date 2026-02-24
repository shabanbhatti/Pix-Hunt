import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';

class CustomTextfieldWidget extends StatelessWidget {
  const CustomTextfieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.prefixIcon,

    required this.onFieldSubmitted,

    required this.validator,
    this.isObscureNotifier,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final IconData prefixIcon;
  final OnValidator validator;
  final OnSubmitted onFieldSubmitted;

  final ValueNotifier<bool>? isObscureNotifier;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.transparent,
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: isObscureNotifier ?? ValueNotifier<bool>(false),
            builder: (context, isObscure, child) {
              return TextFormField(
                obscureText: isObscure,
                controller: controller,
                focusNode: focusNode,
                validator: validator,
                onFieldSubmitted: onFieldSubmitted,

                decoration: InputDecoration(
                  label: Text(label),
                  prefixIcon: Icon(prefixIcon),
                  suffixIcon:
                      (label == 'Password' || label == 'Confirm Password')
                          ? IconButton(
                            onPressed: () {
                              isObscureNotifier?.value =
                                  !isObscureNotifier!.value;
                            },
                            icon: const Icon(Icons.remove_red_eye),
                          )
                          : null,
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
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
