import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20controller/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20controller/auth_state.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/Utils/validations_textfields_utils.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20btns/app_main_btn.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20textfields/password_textfield_widget.dart';
import 'package:pix_hunt_project/core/Widgets/custom_sliver_appbar.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});
  static const pageName = '/change_password';

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage>
    with SingleTickerProviderStateMixin {
  TextEditingController oldPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController newPasswordController = TextEditingController();

  FocusNode oldPasswordFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode btnFocusNode = FocusNode();

  ValueNotifier<bool> OldPasswordObscure = ValueNotifier(true);
  ValueNotifier<bool> newPasswordObscure = ValueNotifier(true);
  // ValueNotifier<bool> OldPasswordObscure = ValueNotifier(true);
  late AnimationController animationController;
  late Animation<double> scaleOldPassword;
  late Animation<double> fadeOldPassword;
  late Animation<double> scaleNewPassword;
  late Animation<double> fadeNewPassword;
  late Animation<double> scaleChangePassBtnDetail;
  late Animation<double> fadeChangePassBtnDetail;
  late Animation<double> scaleChangePassBtn;
  late Animation<double> fadeChangePassBtn;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    fadeOldPassword = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.25),
      ),
    );

    scaleOldPassword = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.25),
      ),
    );

    fadeNewPassword = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.25, 0.50),
      ),
    );

    scaleNewPassword = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.25, 0.50),
      ),
    );

    fadeChangePassBtnDetail = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.50, 0.75),
      ),
    );

    scaleChangePassBtnDetail = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.50, 0.75),
      ),
    );

    fadeChangePassBtn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.75, 1.0),
      ),
    );

    scaleChangePassBtn = Tween<double>(begin: 0.8, end: 1.0).animate(
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
    newPasswordController.dispose();
    animationController.dispose();
    OldPasswordObscure.dispose();
    oldPasswordController.dispose();
    oldPasswordFocusNode.dispose();
    btnFocusNode.dispose();
    newPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('changePassword page build called');
    var lng = AppLocalizations.of(context);
    ref.listen(authProvider(AuthKeys.changePassword), (previous, next) async {
      if (next is AuthLoading) {
        EasyLoading.show();
      }
      if (next is AuthLoadedSuccessfuly) {
        EasyLoading.dismiss();
        ToastUtils.showToast(lng?.passwordChangeSuccessfully ?? '');
        Navigator.of(context).pop();
      }
      if (next is AuthError) {
        EasyLoading.dismiss();
        var error = next.error;

        ToastUtils.showToast(error, color: Colors.red);
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: lng?.changePassword ?? ''),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: scaleOldPassword,
                        child: FadeTransition(
                          opacity: fadeOldPassword,
                          child: CustomPasswordTextFieldWidget(
                            controller: oldPasswordController,
                            focusNode: oldPasswordFocusNode,
                            label: lng?.oldPassword ?? '',
                            isObscure: OldPasswordObscure,
                            onFieldSubmitted: (v) {
                              FocusScope.of(
                                context,
                              ).requestFocus(newPasswordFocusNode);
                            },
                            validator: (v) {
                              return ValidationsTextfieldsUtils.passwordValidation(
                                v,
                                context,
                              );
                            },
                          ),
                        ),
                      ),

                      ScaleTransition(
                        scale: scaleNewPassword,
                        child: FadeTransition(
                          opacity: fadeNewPassword,
                          child: CustomPasswordTextFieldWidget(
                            controller: newPasswordController,
                            focusNode: newPasswordFocusNode,
                            isObscure: newPasswordObscure,
                            validator: (v) {
                              return ValidationsTextfieldsUtils.passwordValidation(
                                v,
                                context,
                              );
                            },
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(btnFocusNode);
                            },
                            label: lng?.newPassword ?? '',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 10, top: 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ScaleTransition(
                            scale: scaleChangePassBtnDetail,
                            child: FadeTransition(
                              opacity: fadeChangePassBtnDetail,
                              child: Text(
                                '*${lng?.changePasswordDetailDes ?? ''}',
                                style: TextStyle(
                                  fontSize: 12,

                                  color: ConstantColors.appColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Consumer(
                        builder: (context, ref, child) {
                          var myRef = ref.watch(
                            authProvider(AuthKeys.changePassword),
                          );
                          return ScaleTransition(
                            scale: scaleChangePassBtn,
                            child: FadeTransition(
                              opacity: fadeChangePassBtn,
                              child: AppMainBtn(
                                focusNode: btnFocusNode,
                                widgetOrTitle: WidgetOrTitle.widget,
                                btnValueWidget:
                                    (myRef is AuthLoading)
                                        ? const CupertinoActivityIndicator(
                                          color: Colors.white,
                                        )
                                        : Text(
                                          lng?.changePassword ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                onTap:
                                    (myRef is AuthLoading)
                                        ? () {
                                          print('Loading');
                                        }
                                        : () {
                                          print('Run');
                                          var formValidate =
                                              formKey.currentState
                                                  ?.validate() ??
                                              false;

                                          if (formValidate) {
                                            ref
                                                .read(
                                                  authProvider(
                                                    AuthKeys.changePassword,
                                                  ).notifier,
                                                )
                                                .changePassword(
                                                  oldPasswordController.text,
                                                  newPasswordController.text,
                                                );
                                          }
                                        },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
