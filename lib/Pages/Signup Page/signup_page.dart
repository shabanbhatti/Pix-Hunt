import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/Utils/toast.dart';
import 'package:pix_hunt_project/Widgets/Signup%20&%20login%20text%20form%20field/text_form_field.dart';
import 'package:pix_hunt_project/Widgets/custom%20btns/app_main_btn.dart';

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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        ToastUtils.showToast(
          'Account verification link has sent to your email (SPAM folder), Please verify your email.',
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
                const SliverToBoxAdapter(
                  child: const Text(
                    'Create your account',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      EmailField(
                        isForName: true,
                        controller: nameController,
                        focusNode: nameFocusNode,
                        label: 'Name',
                        prefixIcon: Icons.person,

                        onFieldSubmitted:
                            (p0) => FocusScope.of(
                              context,
                            ).requestFocus(emailFocusNode),
                      ),
                      const SizedBox(height: 10),
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
                            ).requestFocus(confirmPassFocusNode),
                      ),
                      const SizedBox(height: 10),
                      ConfirmPasswordField(
                        controller: confirmPassController,
                        focusNode: confirmPassFocusNode,
                        onFieldSubmitted:
                            (p0) => FocusScope.of(
                              context,
                            ).requestFocus(buttonFocusNode),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field should not be empty';
                          } else if (value != passwordController.text) {
                            return 'Password does not match to create password';
                          }
                          return null;
                        },
                      ),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '*Hit that button to enjoy high quality photos and \n download them instantly.',
                          style: TextStyle(
                            fontSize: 12,

                            color: Color.fromARGB(255, 77, 91, 172),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      _signupButton(buttonFocusNode, formKey),
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
                  : const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white),
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
