import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20controller/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20controller/auth_state.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Forgot%20Password%20Page/forget_pass.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Home%20Page/home.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/widgets/login_sliver_appbar.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/widgets/login_title_widget.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Signup%20Page/signup_page.dart';
import 'package:pix_hunt_project/core/Utils/validations_textfields_utils.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20textfields/custom_textfield_widget.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/constants/constant_imgs.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20btns/app_main_btn.dart';
import 'package:pix_hunt_project/core/constants/constants_sharedPref_keys.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/core/services/shared_preference_service.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  static const pageName = '/login';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode buttonFocusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AnimationController animationController;
  late Animation<double> scaleTitle;
  late Animation<double> fadeTitle;
  late Animation<double> scaleEmailField;
  late Animation<double> fadeEmailField;
  late Animation<double> scalePasswordField;
  late Animation<double> fadePasswordField;
  late Animation<double> scaleLoginbtn;
  late Animation<double> fadeLoginBtn;
  late Animation<double> scaleCreateAccount;
  late Animation<double> fadeCreateAccount;

  ValueNotifier<String> languageNotifier = ValueNotifier('en');
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    fadeTitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Interval(0.0, 0.2)),
    );

    scaleTitle = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 0.2, curve: Curves.linear),
      ),
    );

    fadeEmailField = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Interval(0.2, 0.4)),
    );

    scaleEmailField = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.2, 0.4, curve: Curves.linear),
      ),
    );

    fadePasswordField = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Interval(0.4, 0.6)),
    );

    scalePasswordField = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.4, 0.6, curve: Curves.linear),
      ),
    );
    // --------------------------------------------
    scaleLoginbtn = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.6, 0.8, curve: Curves.linear),
      ),
    );
    fadeLoginBtn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Interval(0.6, 0.8)),
    );

    scaleCreateAccount = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.8, 1.0, curve: Curves.linear),
      ),
    );
    fadeCreateAccount = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Interval(0.8, 1.0)),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward();
    });
    getCurrentLanguage();
  }

  void getCurrentLanguage() async {
    var sharedPreferencesService = getIt<SharedPreferencesService>();
    var language =
        await sharedPreferencesService.getString(
          ConstantsSharedprefKeys.languageKey,
        ) ??
        'en';
    languageNotifier.value = language;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    animationController.dispose();
    languageNotifier.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Login page build called');
    ref.listen(authProvider(AuthKeys.login), (previous, next) {
      if (next is AuthLoading) {
        EasyLoading.show(
          indicator: Column(
            children: [
              const CupertinoActivityIndicator(color: Colors.white),
              Builder(
                builder:
                    (contextx) => Text(
                      AppLocalizations.of(contextx)?.signingYouIn ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
              ),
            ],
          ),

          dismissOnTap: false,
        );
      }
      if (next is AuthLoadedSuccessfuly) {
        EasyLoading.dismiss();
        ref.read(authProvider(AuthKeys.login).notifier).onLogin();
      }
      if (next is AuthError) {
        EasyLoading.dismiss();
        var error = next.error;
        ToastUtils.showToast(error, color: Colors.red);
      }
    });

    ref.listen(authProvider(AuthKeys.withGoogle), (previous, next) {
      if (next is AuthError) {
        var error = next.error;
        ToastUtils.showToast(error, color: Colors.red);
      }
    });
    return Scaffold(
      body: Center(
        child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                LoginSliverAppbar(languageNotifier: languageNotifier),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: scaleTitle,
                        child: FadeTransition(
                          opacity: fadeTitle,
                          child: const Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsGeometry.only(
                                    bottom: 40,
                                  ),
                                  child: const LoginTitleWidget(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ScaleTransition(
                        scale: scaleEmailField,
                        child: FadeTransition(
                          opacity: fadeEmailField,
                          child: _LoginEmailTextFieldWidget(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            passwordFocusNode: passwordFocusNode,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ScaleTransition(
                        scale: scalePasswordField,
                        child: FadeTransition(
                          opacity: fadePasswordField,
                          child: _LoginPasswordTextFieldWidget(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            btnFocusNode: buttonFocusNode,
                          ),
                        ),
                      ),

                      ScaleTransition(
                        scale: scaleLoginbtn,
                        child: FadeTransition(
                          opacity: fadeLoginBtn,
                          child: const _ForgotButton(),
                        ),
                      ),
                      ScaleTransition(
                        scale: scaleLoginbtn,
                        child: FadeTransition(
                          opacity: fadeLoginBtn,
                          child: _loginButton(buttonFocusNode, formKey),
                        ),
                      ),

                      ScaleTransition(
                        scale: scaleCreateAccount,
                        child: FadeTransition(
                          opacity: fadeCreateAccount,
                          child: _signupbutton(context),
                        ),
                      ),

                      ScaleTransition(
                        scale: scaleCreateAccount,
                        child: FadeTransition(
                          opacity: scaleCreateAccount,
                          child: Consumer(
                            builder: (context, ref, child) {
                              return GestureDetector(
                                onTap: () async {
                                  var isLogged =
                                      await ref
                                          .read(
                                            authProvider(
                                              AuthKeys.login,
                                            ).notifier,
                                          )
                                          .signInWithGOOGLE();
                                  if (isLogged == null) return;

                                  if (isLogged) {
                                    Navigator.of(
                                      context,
                                    ).pushNamedAndRemoveUntil(
                                      Home.pageName,
                                      (route) => false,
                                    );
                                  }
                                },
                                child: const Image(
                                  image: AssetImage(ConstantImgs.google_logo),
                                  height: 50,
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                          ),
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

  Widget _loginButton(FocusNode focusNode, GlobalKey<FormState> formKey) {
    return Consumer(
      builder: (context, ref, child) {
        var myRef = ref.watch(authProvider(AuthKeys.login));
        return AppMainBtn(
          focusNode: focusNode,
          widgetOrTitle: WidgetOrTitle.widget,
          btnValueWidget:
              (myRef is AuthLoading)
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : Text(
                    AppLocalizations.of(context)?.login ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
          onTap: () async {
            var isValidate = formKey.currentState?.validate();
            if (isValidate!) {
              var login = await ref
                  .read(authProvider(AuthKeys.login).notifier)
                  .loginAccount(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
              if (login == null) return;
              print(login);
              if (login) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(Home.pageName, (route) => false);
              } else {
                ToastUtils.showToast(
                  AppLocalizations.of(context)?.emailNotVerified ?? '',
                  color: Colors.red,
                  duration: 4,
                );
              }
            }
          },
        );
      },
    );
  }
}

Widget _signupbutton(BuildContext context) {
  return Builder(
    builder: (contextx) {
      return Padding(
        padding: const EdgeInsets.only(top: 25, bottom: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(contextx)?.ifYouDontHaveAccount ?? ''),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(SignupPage.pageName);
              },
              child: Padding(
                padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                child: Text(
                  AppLocalizations.of(contextx)?.createAccount ?? '',
                  style: TextStyle(
                    decorationColor: ConstantColors.appColor,
                    decoration: TextDecoration.underline,
                    color: ConstantColors.appColor,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _LoginEmailTextFieldWidget extends StatelessWidget {
  const _LoginEmailTextFieldWidget({
    required this.controller,
    required this.focusNode,
    required this.passwordFocusNode,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode passwordFocusNode;
  @override
  Widget build(BuildContext context) {
    var lng = AppLocalizations.of(context);
    return CustomTextfieldWidget(
      validator:
          (value) => ValidationsTextfieldsUtils.emailValidation(value, context),
      controller: controller,
      focusNode: focusNode,
      label: lng?.email ?? '',
      prefixIcon: Icons.mail,

      onFieldSubmitted:
          (p0) => FocusScope.of(context).requestFocus(passwordFocusNode),
    );
  }
}

class _LoginPasswordTextFieldWidget extends StatelessWidget {
  const _LoginPasswordTextFieldWidget({
    required this.controller,
    required this.focusNode,
    required this.btnFocusNode,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode btnFocusNode;
  @override
  Widget build(BuildContext context) {
    return CustomTextfieldWidget(
      controller: controller,
      focusNode: focusNode,
      label: AppLocalizations.of(context)?.password ?? '',
      prefixIcon: Icons.lock,
      validator:
          (value) =>
              ValidationsTextfieldsUtils.passwordValidation(value, context),
      onFieldSubmitted:
          (p0) => FocusScope.of(context).requestFocus(btnFocusNode),
    );
  }
}

class _ForgotButton extends StatelessWidget {
  const _ForgotButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ForgetPassPage.pageName);
            },
            child: Text(
              AppLocalizations.of(context)?.forgotPassword ?? '',
              style: const TextStyle(
                decorationColor: ConstantColors.appColor,
                decoration: TextDecoration.underline,
                color: ConstantColors.appColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
