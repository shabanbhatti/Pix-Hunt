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
import 'package:pix_hunt_project/core/Widgets/custom%20textfields/custom_textfield_widget.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20textfields/password_textfield_widget.dart';

import 'package:pix_hunt_project/core/Widgets/custom_sliver_appbar.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class UpdateEmailPage extends ConsumerStatefulWidget {
  const UpdateEmailPage({super.key});
  static const pageName = '/update_email';

  @override
  ConsumerState<UpdateEmailPage> createState() => _UpdateIdentityPageState();
}

class _UpdateIdentityPageState extends ConsumerState<UpdateEmailPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController passController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode btnFocusNode = FocusNode();

  ValueNotifier<bool> isObscure = ValueNotifier(true);
  late AnimationController animationController;
  late Animation<double> scaleEmail;
  late Animation<double> fadeEmail;
  late Animation<double> scalePassword;
  late Animation<double> fadePassword;
  late Animation<double> scaleUpdateBtnDetail;
  late Animation<double> fadeUpdateBtnDetail;
  late Animation<double> scaleUpdateBtn;
  late Animation<double> fadeUpdateBtn;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    fadeEmail = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.25),
      ),
    );

    scaleEmail = Tween<double>(begin: 0.8, end: 1.0).animate(
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

    fadeUpdateBtnDetail = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.50, 0.75),
      ),
    );

    scaleUpdateBtnDetail = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.50, 0.75),
      ),
    );

    fadeUpdateBtn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.75, 1.0),
      ),
    );

    scaleUpdateBtn = Tween<double>(begin: 0.8, end: 1.0).animate(
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
    passController.dispose();
    animationController.dispose();
    isObscure.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    btnFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Update email page build called');
    var lng = AppLocalizations.of(context);
    ref.listen(authProvider(AuthKeys.updateEmail), (previous, next) async {
      if (next is AuthLoading) {
        EasyLoading.show();
      }
      if (next is AuthLoadedSuccessfuly) {
        EasyLoading.dismiss();
        ToastUtils.showToast(lng?.emailVerificationLink ?? '');
      } else if (next is AuthError) {
        EasyLoading.dismiss();
        var error = next.error;

        ToastUtils.showToast(error, color: Colors.red);
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: lng?.updateEmail ?? ''),
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
                        scale: scaleEmail,
                        child: FadeTransition(
                          opacity: fadeEmail,
                          child: CustomTextfieldWidget(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            label: lng?.newEmail ?? '',
                            prefixIcon: Icons.email,
                            onFieldSubmitted: (v) {
                              FocusScope.of(
                                context,
                              ).requestFocus(passwordFocusNode);
                            },
                            // validator: (v) {
                            //   return ValidationsTextfieldsUtils.emailValidation(
                            //     v,
                            //     context,
                            //   );
                            // },
                            validator: null,
                          ),
                        ),
                      ),

                      ScaleTransition(
                        scale: scalePassword,
                        child: FadeTransition(
                          opacity: fadePassword,
                          child: CustomPasswordTextFieldWidget(
                            controller: passController,
                            focusNode: passwordFocusNode,
                            isObscure: isObscure,
                            validator: (v) {
                              return ValidationsTextfieldsUtils.passwordValidation(
                                v,
                                context,
                              );
                            },
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(btnFocusNode);
                            },
                            label: lng?.password ?? '',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 10, top: 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ScaleTransition(
                            scale: scaleUpdateBtnDetail,
                            child: FadeTransition(
                              opacity: fadeUpdateBtnDetail,
                              child: Text(
                                '*${lng?.updateEmailBtnDetail ?? ''}',
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
                            authProvider(AuthKeys.updateEmail),
                          );
                          return ScaleTransition(
                            scale: scaleUpdateBtn,
                            child: FadeTransition(
                              opacity: fadeUpdateBtn,
                              child: AppMainBtn(
                                focusNode: btnFocusNode,
                                widgetOrTitle: WidgetOrTitle.widget,
                                btnValueWidget:
                                    (myRef is AuthLoading)
                                        ? const CupertinoActivityIndicator(
                                          color: Colors.white,
                                        )
                                        : Text(
                                          AppLocalizations.of(
                                                context,
                                              )?.updateEmail ??
                                              '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                onTap:
                                    (myRef is AuthLoading)
                                        ? () {}
                                        : () {
                                          var emailValidate =
                                              formKey.currentState
                                                  ?.validate() ??
                                              false;

                                          if (emailValidate) {
                                            ref
                                                .read(
                                                  authProvider(
                                                    AuthKeys.updateEmail,
                                                  ).notifier,
                                                )
                                                .updateEmail(
                                                  emailController.text,
                                                  passController.text,
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
