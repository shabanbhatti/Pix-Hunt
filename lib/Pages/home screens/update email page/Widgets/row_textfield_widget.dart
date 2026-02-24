import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class RowTextfieldWidget extends StatefulWidget {
  RowTextfieldWidget({
    super.key,
    required this.controller,
    required this.title,
    required this.formKey,
    required this.isObscure,
  });
  final TextEditingController controller;
  final String title;
  final GlobalKey<FormState> formKey;
  bool isObscure;

  @override
  State<RowTextfieldWidget> createState() => _RowTextfieldWidgetState();
}

class _RowTextfieldWidgetState extends State<RowTextfieldWidget> {
  @override
  Widget build(BuildContext context) {
    print('FIELD UPDATED CALLED');
    var lng = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        Expanded(
          flex: 20,
          child: SizedBox(
            height: 50,
            child: Form(
              key: widget.formKey,
              child: TextFormField(
                obscureText: widget.isObscure,
                style: TextStyle(fontSize: 15),
                validator: (value) {
                  if (value!.isEmpty) {
                    return lng?.fieldShouldNotBeEmpty ?? '';
                  } else {
                    return null;
                  }
                },
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: widget.title,
                  suffixIcon:
                      (widget.title == 'Password')
                          ? IconButton(
                            onPressed: () {
                              widget.isObscure = !widget.isObscure;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.visibility,
                              color: ConstantColors.appColor,
                            ),
                          )
                          : null,
                  hintStyle: const TextStyle(color: Colors.grey),
                  focusColor: ConstantColors.appColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
