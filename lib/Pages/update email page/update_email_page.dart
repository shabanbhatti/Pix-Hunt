import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/on%20sync%20after%20email%20verify%20riverpod/on_sync_after_email_verify.dart';
import 'package:pix_hunt_project/Pages/update%20email%20page/Widgets/row_textfield_widget.dart';
import 'package:pix_hunt_project/Utils/custom_snack_bar.dart';
import 'package:pix_hunt_project/Widgets/custom_app_bar.dart';

class UpdateEmailPage extends ConsumerStatefulWidget {
  const UpdateEmailPage({super.key});
  static const pageName = '/update_email';

  @override
  ConsumerState<UpdateEmailPage> createState() => _UpdateIdentityPageState();
}

class _UpdateIdentityPageState extends ConsumerState<UpdateEmailPage> {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();

  TextEditingController passController = TextEditingController();
  GlobalKey<FormState> passKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('UPDATE DATA BUILD CALLED');
    ref.listen(authProvider('update'), (previous, next) async {
      if (next is AuthLoadedSuccessfuly) {
        snackbar(
          context,
          'Email verification link sent to your new email, please verify',
        );
      } else if (next is AuthError) {
        var error = next.error;
        snackbar(context, error, color: Colors.red);
      }
    });
    return Scaffold(
      appBar: customAppBar(
        'Update Identity',
        onTap: () async {
          var isSync =
              await ref
                  .read(onSyncAfterEmailVerifyProvider.notifier)
                  .syncEmailAfterVerification();
          if (isSync) {
            Navigator.pop(context);
          }
        },
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              RowTextfieldWidget(
                controller: emailController,
                title: 'Email',

                formKey: emailKey,
                isObscure: false,
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: RowTextfieldWidget(
                  controller: passController,
                  title: 'Password',
                  isObscure: true,
                  formKey: passKey,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: _updateButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _updateButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: mqSize.width * 0.87,
          child: Consumer(
            builder: (context, ref, child) {
              var myRef = ref.watch(authProvider('update'));
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // var nameValidate = nameKey.currentState!.validate();
                  var emailValidate = emailKey.currentState!.validate();
                  var passValidate = passKey.currentState!.validate();

                  if (emailValidate && passValidate) {
                    ref
                        .read(authProvider('update').notifier)
                        .updateEmail(emailController.text, passController.text);
                  }
                },
                child:
                    (myRef is AuthLoading)
                        ? CupertinoActivityIndicator(color: Colors.white)
                        : Text('Update', style: TextStyle(color: Colors.white)),
              );
            },
          ),
        );
      },
    );
  }
}
