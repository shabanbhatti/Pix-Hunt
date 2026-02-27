import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20controller/user_db_riverpod.dart';
import 'package:pix_hunt_project/core/Utils/dialog%20boxes/delete_dialog_boxes.dart';
import 'package:pix_hunt_project/core/Utils/validations_textfields_utils.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20btns/app_main_btn.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20textfields/password_textfield_widget.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class DeleteAccountWidget extends ConsumerStatefulWidget {
  const DeleteAccountWidget({super.key});

  @override
  ConsumerState<DeleteAccountWidget> createState() =>
      _DeleteAccountWidgetState();
}

class _DeleteAccountWidgetState extends ConsumerState<DeleteAccountWidget>
    with SingleTickerProviderStateMixin {
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode btnFocusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey();
  ValueNotifier<bool> isObscureNotifier = ValueNotifier(true);
  late AnimationController animationController;
  late Animation<double> scaleTitle;
  late Animation<double> fadeTitle;
  late Animation<double> scalePassword;
  late Animation<double> fadePassword;
  late Animation<double> scaleBtnDetail;
  late Animation<double> fadeBtnDetail;
  late Animation<double> scaleBtn;
  late Animation<double> fadeBtn;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    fadeTitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.25),
      ),
    );

    scaleTitle = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.25),
      ),
    );

    fadePassword = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.25, 0.50),
      ),
    );

    scalePassword = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.25, 0.50),
      ),
    );

    fadeBtnDetail = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.50, 0.75),
      ),
    );

    scaleBtnDetail = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.50, 0.75),
      ),
    );

    fadeBtn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.75, 1.0),
      ),
    );

    scaleBtn = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.75, 1.0),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    btnFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lng = AppLocalizations.of(context);
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(CupertinoIcons.xmark_circle_fill, size: 30),
              ),
            ],
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsetsGeometry.only(
                    left: 10,
                    bottom: 15,
                    right: 10,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: ScaleTransition(
                      scale: scaleTitle,
                      child: FadeTransition(
                        opacity: fadeTitle,
                        child: Text(
                          lng?.account_deletion_title ?? '',
                          style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsetsGeometry.only(
                    right: 10,
                    left: 10,
                    top: 20,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: ScaleTransition(
                      scale: scalePassword,
                      child: FadeTransition(
                        opacity: fadePassword,
                        child: CustomPasswordTextFieldWidget(
                          autofocus: true,
                          controller: passwordController,
                          focusNode: passwordFocusNode,
                          isObscure: isObscureNotifier,
                          validator:
                              (v) =>
                                  ValidationsTextfieldsUtils.passwordValidation(
                                    v,
                                    context,
                                  ),
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(btnFocusNode);
                          },
                          label: lng?.password ?? '',
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsetsGeometry.only(right: 10, left: 10),
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(bottom: 10, top: 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ScaleTransition(
                          scale: scaleBtnDetail,
                          child: FadeTransition(
                            opacity: fadeBtnDetail,
                            child: Text(
                              '*${lng?.delete_warning ?? ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: ConstantColors.appColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsetsGeometry.only(right: 10, left: 10),
                  sliver: SliverToBoxAdapter(
                    child: ScaleTransition(
                      scale: scaleBtn,
                      child: FadeTransition(
                        opacity: fadeBtn,
                        child: AppMainBtn(
                          focusNode: btnFocusNode,
                          onTap: () {
                            var isValidate = formKey.currentState?.validate();

                            if (isValidate ?? false) {
                              deleteDialogBox(
                                context,
                                delete: () async {
                                  await ref
                                      .read(userDbProvider.notifier)
                                      .deleteAccount(
                                        passwordController.text.trim(),
                                      );
                                },
                                title: lng?.delete_account ?? '',
                                describtion:
                                    lng?.delete_confirmation_message ?? '',
                              );
                            }
                          },
                          widgetOrTitle: WidgetOrTitle.title,
                          btnTitle: lng?.confirm_deletion ?? '',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
