import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Pages/Forgot%20Password%20Page/forget_pass.dart';
import 'package:pix_hunt_project/Pages/Home%20Page/home.dart';
import 'package:pix_hunt_project/Pages/Signup%20Page/signup_page.dart';
import 'package:pix_hunt_project/Utils/constant_mgs.dart';
import 'package:pix_hunt_project/Widgets/Signup%20&%20login%20text%20form%20field/text_form_field.dart';
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
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();

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
ref.listen(authProvider('login'),(previous, next) {
  if (next is AuthLoadedSuccessfuly) {
    Navigator.of(context).pushNamedAndRemoveUntil(Home.pageName, (route) => false,);
  }else if(next is AuthError){
    var error= next.error;
 ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error-----login'), backgroundColor: Colors.red),
      );
  }
},);

ref.listen(authProvider('google'),(previous, next) {
  if (next is AuthLoadedSuccessfuly) {
    Navigator.of(context).pushNamedAndRemoveUntil(Home.pageName, (route) => false,);
  }else if(next is AuthError){
    var error= next.error;
 ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error-----login'), backgroundColor: Colors.red),
      );
  }
},);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 70),
            _topLogo(),
            Padding(
              padding: EdgeInsets.all(35),
              child: const Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),

            EmailField(
              controller: emailController,
              focusNode: emailFocusNode,
              label: 'Email',
              prefixIcon: Icons.mail,

              onFieldSubmitted:
                  (p0) =>
                      FocusScope.of(context).requestFocus(passwordFocusNode),
            ),
            const SizedBox(height: 40),
            PasswordField(
              controller: passwordController,
              focusNode: passwordFocusNode,

              onFieldSubmitted:
                  (p0) => FocusScope.of(context).requestFocus(buttonFocusNode),
            ),
            const SizedBox(height: 40),
            _loginButton(buttonFocusNode),
            _forgotPsswordButton(),
            _signupbutton(),

            Consumer(
              builder: (context, ref, child) {
                return InkWell(
                  onTap: () {
                    ref.read(authProvider('login').notifier).signInWithGOOGLE();
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
    );
  }

  Widget _loginButton(FocusNode focusNode) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: mqSize.width * 0.87,
          child: Consumer(
            builder: (context, ref, child) {
              var myRef = ref.watch(authProvider('login'));
              return ElevatedButton(
                focusNode: focusNode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fields should not be empty'),
                      ),
                    );
                  } else {
                    ref
                        .read(authProvider('login').notifier)
                        .loginAccount(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          
                        );
                  }
                },
                child:
                    (myRef is AuthLoading)
                        ? CupertinoActivityIndicator(color: Colors.white)
                        : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget _topLogo() => LayoutBuilder(
  builder: (context, constraints) {
    var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
    return Hero(
      tag: 'into_to_login',
      flightShuttleBuilder:
          (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) => RotationTransition(
            turns: animation.drive(Tween(begin: 0.0, end: 2 * pi)),
            child: fromHeroContext.widget,
          ),
      child: Image.asset(
        app_logo,
        width: mqSize.width * 0.4,
        fit: BoxFit.fitWidth,
      ),
    );
  },
);

Widget _forgotPsswordButton() {
  return Padding(
    padding: const EdgeInsets.only(right: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(
              navigatorKey.currentContext!,
            ).pushNamed(ForgetPassPage.pageName);
          },
          child: const Text(
            'Forgot password?',
            style: TextStyle(
              color: Color.fromARGB(255, 77, 91, 172),
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _signupbutton() {
  return Padding(
    padding: EdgeInsets.only(top: 25),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("If you don't have an account"),
        TextButton(
          onPressed: () {
            Navigator.of(
              navigatorKey.currentContext!,
            ).pushNamed(SignupPage.pageName);
          },
          child: const Text(
            'Create account',
            style: TextStyle(
              color: Color.fromARGB(255, 77, 91, 172),
              fontWeight: FontWeight.bold,
              fontSize: 17,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    ),
  );
}
