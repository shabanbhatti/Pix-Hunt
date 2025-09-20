import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/Utils/constant_mgs.dart';
import 'package:pix_hunt_project/Widgets/Signup%20&%20login%20text%20form%20field/text_form_field.dart';
import 'package:pix_hunt_project/Widgets/custom_app_bar.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});
  static const pageName = '/signup';

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode confirmPassFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode buttonFocusNode = FocusNode();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> confirmPassKey = GlobalKey<FormState>();
  GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();




@override
  void initState() {
    super.initState();

  }




  @override
  void dispose() {
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
   ref.listen(authProvider('create'), (previous, next) {
  if (next is AuthLoadedSuccessfuly) {
    ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Account created successfuly'),
                                backgroundColor: Colors.green,
                              ),
                            );
    Navigator.pop(context);
  }else if(next is AuthError){
    var error= next.error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error-----sign up'), backgroundColor: Colors.red),
      );
  }
},);


    return Scaffold(
      appBar: customAppBar(''),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _topLogo(),
            Padding(
              padding: EdgeInsets.all(20),
              child: const Text(
                'Sign up',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),

            EmailField(
              controller: nameController,
              focusNode: nameFocusNode,
              label: 'Name',
              prefixIcon: Icons.person,

              onFieldSubmitted:
                  (p0) => FocusScope.of(context).requestFocus(emailFocusNode),
            ),
            const SizedBox(height: 25),
            EmailField(
              controller: emailController,
              focusNode: emailFocusNode,
              label: 'Email',
              prefixIcon: Icons.mail,

              onFieldSubmitted:
                  (p0) =>
                      FocusScope.of(context).requestFocus(passwordFocusNode),
            ),
            const SizedBox(height: 25),
            PasswordField(
              controller: passwordController,
              focusNode: passwordFocusNode,

              onFieldSubmitted:
                  (p0) =>
                      FocusScope.of(context).requestFocus(confirmPassFocusNode),
            ),
            const SizedBox(height: 25),
            ConfirmPasswordField(
              controller: confirmPassController,
              focusNode: confirmPassFocusNode,
              onFieldSubmitted:
                  (p0) => FocusScope.of(context).requestFocus(buttonFocusNode),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Field should not be empty';
                } else if (value != passwordController.text) {
                  return 'Password does not match to create password';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            _signupButton(buttonFocusNode),
          ],
        ),
      ),
    );
  }

  Widget _signupButton(FocusNode focusNode) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: mqSize.width * 0.87,
          child: Consumer(
            builder: (context, ref, child) {
              var myRef = ref.watch(authProvider('create'));



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
                      passwordController.text.isEmpty ||
                      nameController.text.isEmpty ||
                      confirmPassController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fields should not be empty'),
                      ),
                    );
                  } else {
                    if (passwordController.text != confirmPassController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password are not equal')),
                      );
                    } else {
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
                  }
                },
                child:
                    myRef is AuthLoading
                        ? CupertinoActivityIndicator(color: Colors.white)
                        : const Text(
                          'Sign up',
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
    return Padding(
      padding: EdgeInsets.all(10),
      child: Hero(
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
          width: mqSize.width * 0.3,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  },
);
