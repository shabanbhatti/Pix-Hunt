import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';

import 'package:pix_hunt_project/Pages/update%20email%20page/Widgets/row_textfield_widget.dart';
import 'package:pix_hunt_project/Utils/toast.dart';
import 'package:pix_hunt_project/Widgets/custom%20btns/app_main_btn.dart';

import 'package:pix_hunt_project/Widgets/custom_sliver_appbar.dart';

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
        ToastUtils.showToast(
          'Email verification link sent to your new email, please verify',
        );
      } else if (next is AuthError) {
        var error = next.error;

        ToastUtils.showToast(error, color: Colors.red);
      }
    });
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(title: 'Update email'),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
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
                      padding: EdgeInsets.only(top: 40),
                      child: _updateButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _updateButton() {
    return Consumer(
      builder: (context, ref, child) {
        var myRef = ref.watch(authProvider('update'));
        return AppMainBtn(
          widgetOrTitle: WidgetOrTitle.widget,
          btnValueWidget:
              (myRef is AuthLoading)
                  ? CupertinoActivityIndicator(color: Colors.white)
                  : Text('Update name', style: TextStyle(color: Colors.white)),
          onTap: () {
            // var nameValidate = nameKey.currentState!.validate();
            var emailValidate = emailKey.currentState!.validate();
            var passValidate = passKey.currentState!.validate();

            if (emailValidate && passValidate) {
              ref
                  .read(authProvider('update').notifier)
                  .updateEmail(emailController.text, passController.text);
            }
          },
        );
      },
    );
  }
}
