
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Pages/Forgot%20Password%20Page/forget_pass.dart';
import 'package:pix_hunt_project/Pages/Home%20Page/home.dart';
import 'package:pix_hunt_project/Pages/Signup%20Page/signup_page.dart';
import 'package:pix_hunt_project/Utils/constant_mgs.dart';
import 'package:pix_hunt_project/Utils/toast.dart';
import 'package:pix_hunt_project/Widgets/Signup%20&%20login%20text%20form%20field/text_form_field.dart';
import 'package:pix_hunt_project/Widgets/custom%20btns/app_main_btn.dart';
import 'package:pix_hunt_project/main.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  static const pageName = '/login';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode buttonFocusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('LOGIN BUILD CALLED');
    ref.listen(authProvider('login'), (previous, next) {
      if (next is AuthLoading) {
        EasyLoading.show(
          indicator: const CupertinoActivityIndicator(color: Colors.white),
          status: 'Signing you in...',
          dismissOnTap: false,
        );
      }
      if (next is AuthLoadedSuccessfuly) {
        EasyLoading.dismiss();
      }
      if (next is AuthError) {
        EasyLoading.dismiss();
        var error = next.error;
        ToastUtils.showToast(error, color: Colors.red);
      }
    });

    ref.listen(authProvider('google'), (previous, next) {
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
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      _topLogo(),
                      Padding(
                        padding: const EdgeInsetsGeometry.symmetric(
                          vertical: 20,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),

                      EmailField(
                        isForName: false,
                        controller: emailController,
                        focusNode: emailFocusNode,
                        label: 'Email',
                        prefixIcon: Icons.mail,

                        onFieldSubmitted:
                            (p0) => FocusScope.of(
                              context,
                            ).requestFocus(passwordFocusNode),
                      ),
                      const SizedBox(height: 10),
                      PasswordField(
                        controller: passwordController,
                        focusNode: passwordFocusNode,

                        onFieldSubmitted:
                            (p0) => FocusScope.of(
                              context,
                            ).requestFocus(buttonFocusNode),
                      ),

                      _forgotPsswordButton(),
                      _loginButton(buttonFocusNode, formKey),

                      _signupbutton(),

                      Consumer(
                        builder: (context, ref, child) {
                          return GestureDetector(
                            onTap: () async {
                              var isLogged =
                                  await ref
                                      .read(authProvider('login').notifier)
                                      .signInWithGOOGLE();
                              if (isLogged == null) return;

                              if (isLogged) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  Home.pageName,
                                  (route) => false,
                                );
                              }
                            },
                            child: const Image(
                              image: AssetImage(google_logo),
                              height: 50,
                              fit: BoxFit.fill,
                            ),
                          );
                        },
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
        var myRef = ref.watch(authProvider('login'));
        return AppMainBtn(
          focusNode: focusNode,
          widgetOrTitle: WidgetOrTitle.widget,
          btnValueWidget:
              (myRef is AuthLoading)
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : const Text('Login', style: TextStyle(color: Colors.white)),
          onTap: () async {
            var isValidate = formKey.currentState?.validate();
            if (isValidate!) {
              var login = await ref
                  .read(authProvider('login').notifier)
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
                  'Email is not verified! Please verify your email before login',
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

Widget _topLogo() => Hero(
  tag: 'into_to_login',

  child: Image.asset(
    app_logo,
    height: 150,
    width: double.infinity,
    fit: BoxFit.fitHeight,
  ),
);

Widget _forgotPsswordButton() {
  return Padding(
    padding: const EdgeInsetsGeometry.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(
              navigatorKey.currentContext!,
            ).pushNamed(ForgetPassPage.pageName);
          },
          child: const Text(
            'Forgot password?',
            style: const TextStyle(
              decorationColor: Color.fromARGB(255, 77, 91, 172),
              decoration: TextDecoration.underline,
              color: Color.fromARGB(255, 77, 91, 172),
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _signupbutton() {
  return Padding(
    padding: const EdgeInsets.only(top: 25, bottom: 20),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("If you don't have an account"),
        GestureDetector(
          onTap: () {
            Navigator.of(
              navigatorKey.currentContext!,
            ).pushNamed(SignupPage.pageName);
          },
          child: Padding(
            padding: EdgeInsetsGeometry.only(left: 10),
            child: const Text(
              'Create account',
              style: TextStyle(
                decorationColor: Color.fromARGB(255, 77, 91, 172),
                decoration: TextDecoration.underline,
                color: Color.fromARGB(255, 77, 91, 172),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
