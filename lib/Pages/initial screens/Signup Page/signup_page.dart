import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_state.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/Widgets/Signup%20&%20login%20text%20form%20field/text_form_field.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20btns/app_main_btn.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});
  static const pageName = '/signup';

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode confirmPassFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode buttonFocusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AnimationController animationController;
  late Animation<double> scaleTitle;
  late Animation<double> fadeTitle;
  late Animation<double> scaleNameField;
  late Animation<double> fadeNameField;
  late Animation<double> scaleEmailField;
  late Animation<double> fadeEmailField;
  late Animation<double> scalePasswordField;
  late Animation<double> fadePasswordField;
  late Animation<double> scaleConfirmPasswordField;
  late Animation<double> fadeConfirmPasswordField;
  late Animation<double> scaleDetailTitle;
  late Animation<double> fadeDetailTitle;
  late Animation<double> scaleCreateAccountBtn;
  late Animation<double> fadeCreateAccountBtn;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    fadeTitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.15),
      ),
    );

    scaleTitle = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.15, curve: Curves.linear),
      ),
    );

    fadeNameField = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.15, 0.3),
      ),
    );

    scaleNameField = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.15, 0.3, curve: Curves.linear),
      ),
    );

    fadeEmailField = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 0.45),
      ),
    );

    scaleEmailField = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 0.45, curve: Curves.linear),
      ),
    );

    fadePasswordField = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.45, 0.6),
      ),
    );

    scalePasswordField = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.45, 0.6, curve: Curves.linear),
      ),
    );

    fadeConfirmPasswordField = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 0.75),
      ),
    );

    scaleConfirmPasswordField = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 0.75, curve: Curves.linear),
      ),
    );

    scaleDetailTitle = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.75, 0.9, curve: Curves.linear),
      ),
    );
    fadeDetailTitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.75, 0.9),
      ),
    );

    scaleCreateAccountBtn = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.9, 1.0, curve: Curves.linear),
      ),
    );
    fadeCreateAccountBtn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.9, 1.0),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    confirmPassController.dispose();
    nameController.dispose();
    nameFocusNode.dispose();
    confirmPassFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lng = AppLocalizations.of(context);
    ref.listen(authProvider('create'), (previous, next) {
      if (next is AuthLoadedSuccessfuly) {
        ToastUtils.showToast(
          lng?.accountVerificationLinkSent ?? '',
          duration: 5,
        );
        Navigator.pop(context);
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
                  padding: EdgeInsetsGeometry.symmetric(vertical: 10),
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
                              lng?.createAccount ?? '',
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
                      const SizedBox(height: 30),
                      ScaleTransition(
                        scale: scaleNameField,
                        child: FadeTransition(
                          opacity: fadeNameField,
                          child: EmailField(
                            isForName: true,
                            controller: nameController,
                            focusNode: nameFocusNode,
                            label: lng?.name ?? '',
                            prefixIcon: Icons.person,

                            onFieldSubmitted:
                                (p0) => FocusScope.of(
                                  context,
                                ).requestFocus(emailFocusNode),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ScaleTransition(
                        scale: scaleEmailField,
                        child: FadeTransition(
                          opacity: fadeEmailField,
                          child: EmailField(
                            isForName: false,
                            controller: emailController,
                            focusNode: emailFocusNode,
                            label: lng?.email ?? '',
                            prefixIcon: Icons.mail,

                            onFieldSubmitted:
                                (p0) => FocusScope.of(
                                  context,
                                ).requestFocus(passwordFocusNode),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ScaleTransition(
                        scale: scalePasswordField,
                        child: FadeTransition(
                          opacity: fadePasswordField,
                          child: PasswordField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,

                            onFieldSubmitted:
                                (p0) => FocusScope.of(
                                  context,
                                ).requestFocus(confirmPassFocusNode),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ScaleTransition(
                        scale: scaleConfirmPasswordField,
                        child: FadeTransition(
                          opacity: fadeConfirmPasswordField,
                          child: ConfirmPasswordField(
                            controller: confirmPassController,
                            focusNode: confirmPassFocusNode,
                            onFieldSubmitted:
                                (p0) => FocusScope.of(
                                  context,
                                ).requestFocus(buttonFocusNode),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return lng?.fieldShouldNotBeEmpty ?? '';
                              } else if (value != passwordController.text) {
                                return lng?.passwordDoesntMatch ?? '';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: ScaleTransition(
                          scale: scaleDetailTitle,
                          child: FadeTransition(
                            opacity: fadeDetailTitle,
                            child: Text(
                              '*${lng?.createBtnDetail ?? ''}',
                              style: TextStyle(
                                fontSize: 12,

                                color: Color.fromARGB(255, 77, 91, 172),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ScaleTransition(
                        scale: scaleCreateAccountBtn,
                        child: FadeTransition(
                          opacity: fadeCreateAccountBtn,
                          child: _signupButton(buttonFocusNode, formKey),
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

  Widget _signupButton(FocusNode focusNode, GlobalKey<FormState> formKey) {
    return Consumer(
      builder: (context, ref, child) {
        var myRef = ref.watch(authProvider('create'));

        return AppMainBtn(
          focusNode: focusNode,
          widgetOrTitle: WidgetOrTitle.widget,
          btnValueWidget:
              myRef is AuthLoading
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : Text(
                    AppLocalizations.of(context)?.signup ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
          onTap: () {
            var isValidate = formKey.currentState?.validate();
            if (isValidate!) {
              ref
                  .read(authProvider('create').notifier)
                  .createAccount(
                    auth: Auth(
                      name: nameController.text.trim(),
                      createdAtDate: DateTime.now().toString(),
                      email: emailController.text..trim(),
                    ),
                    password: passwordController.text.trim(),
                  );
            }
          },
        );
      },
    );
  }
}
