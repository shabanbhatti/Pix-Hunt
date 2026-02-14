import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_state.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/Widgets/Signup%20&%20login%20text%20form%20field/text_form_field.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20btns/app_main_btn.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ForgetPassPage extends ConsumerStatefulWidget {
  const ForgetPassPage({super.key});

  static const pageName = '/forget_pass';

  @override
  ConsumerState<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends ConsumerState<ForgetPassPage>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey();
  late AnimationController animationController;
  late Animation<double> scaleTitle;
  late Animation<double> fadeTitle;
  late Animation<double> scaleDescribtion;
  late Animation<double> fadeDescribtion;
  late Animation<double> scaleEmailField;
  late Animation<double> fadeEmailField;
  late Animation<double> scaleSendBtn;
  late Animation<double> fadeSendBtn;
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
        curve: const Interval(0.0, 0.2),
      ),
    );

    scaleTitle = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.2, curve: Curves.linear),
      ),
    );

    fadeEmailField = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.4),
      ),
    );

    scaleEmailField = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.4, curve: Curves.linear),
      ),
    );

    fadeDescribtion = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 0.6),
      ),
    );

    scaleDescribtion = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 0.6, curve: Curves.linear),
      ),
    );

    fadeSendBtn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 1.0),
      ),
    );

    scaleSendBtn = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.linear),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Forgot password page build called');
    var lng = AppLocalizations.of(context);
    ref.listen(authProvider('forgot'), (previous, next) {
      if (next is AuthLoadedSuccessfuly) {
        ToastUtils.showToast("${lng?.passwordResetLinkSent ?? ''}");
      } else if (next is AuthError) {
        var error = next.error;
        ToastUtils.showToast(error, color: Colors.red);
      }
    });
    return Scaffold(
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsetsGeometry.symmetric(vertical: 10),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            CupertinoIcons.xmark_circle,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: ScaleTransition(
                          scale: scaleTitle,
                          child: FadeTransition(
                            opacity: fadeTitle,
                            child: Text(
                              lng?.forgotYourPassword ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ScaleTransition(
                          scale: scaleEmailField,
                          child: FadeTransition(
                            opacity: fadeEmailField,
                            child: EmailField(
                              isForName: false,
                              controller: controller,
                              focusNode: focusNode,
                              label: lng?.email ?? '',
                              prefixIcon: Icons.mail,
                              onFieldSubmitted: (p0) {
                                FocusScope.of(context).requestFocus(focusNode);
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ScaleTransition(
                            scale: scaleDescribtion,
                            child: FadeTransition(
                              opacity: fadeDescribtion,
                              child: Text(
                                '*${lng?.forgotBtnDetail ?? ''}',
                                style: TextStyle(
                                  fontSize: 12,

                                  color: Color.fromARGB(255, 77, 91, 172),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      ScaleTransition(
                        scale: scaleSendBtn,
                        child: FadeTransition(
                          opacity: fadeSendBtn,
                          child: _forgotBtn(focusNode, controller, formKey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _forgotBtn(
  FocusNode focusNode,
  TextEditingController controller,
  GlobalKey<FormState> formKey,
) {
  return Consumer(
    builder: (context, ref, child) {
      var myRef = ref.watch(authProvider('forgot'));
      return AppMainBtn(
        widgetOrTitle: WidgetOrTitle.widget,
        btnValueWidget:
            (myRef is AuthLoading)
                ? CupertinoActivityIndicator(color: Colors.white)
                : Text(
                  AppLocalizations.of(context)?.sentLink ?? '',
                  style: TextStyle(color: Colors.white),
                ),
        focusNode: focusNode,

        onTap: () {
          var isValidate = formKey.currentState!.validate();
          if (isValidate) {
            ref
                .read(authProvider('forgot').notifier)
                .forgotPassword(controller.text.trim());
          }
        },
      );
    },
  );
}
