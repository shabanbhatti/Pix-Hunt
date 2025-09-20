import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Widgets/Signup%20&%20login%20text%20form%20field/text_form_field.dart';
import 'package:pix_hunt_project/Widgets/custom_app_bar.dart';

class ForgetPassPage extends ConsumerStatefulWidget {
  const ForgetPassPage({super.key});

  static const pageName = '/forget_pass';

  @override
  ConsumerState<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends ConsumerState<ForgetPassPage> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider('forgot'), (previous, next) {
      if (next is AuthLoadedSuccessfuly) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password reset link sent to your email (spam)."),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (next is AuthError) {
        var error = next.error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    });
    return Scaffold(
      appBar: customAppBar('Forgot password'),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: EmailField(
                controller: controller,
                focusNode: focusNode,
                label: 'Email',
                prefixIcon: Icons.mail,
                onFieldSubmitted: (p0) {},
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: _loginButton(focusNode, controller),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _loginButton(FocusNode focusNode, TextEditingController controller) {
  return LayoutBuilder(
    builder: (context, constraints) {
      var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
      return SizedBox(
        width: mqSize.width * 0.87,
        child: Consumer(
          builder: (context, ref, child) {
            var myRef = ref.watch(authProvider('forgot'));
            return ElevatedButton(
              focusNode: focusNode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                ref
                    .read(authProvider('forgot').notifier)
                    .forgotPassword(controller.text.trim());
              },
              child:
                  (myRef is AuthLoading)
                      ? CupertinoActivityIndicator(color: Colors.white)
                      : const Text(
                        'Forgot password',
                        style: TextStyle(color: Colors.white),
                      ),
            );
          },
        ),
      );
    },
  );
}
