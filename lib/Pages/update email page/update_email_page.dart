import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';

import 'package:pix_hunt_project/Pages/update%20email%20page/Widgets/row_textfield_widget.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20btns/app_main_btn.dart';

import 'package:pix_hunt_project/core/Widgets/custom_sliver_appbar.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

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
    var lng = AppLocalizations.of(context);
    ref.listen(authProvider('update'), (previous, next) async {
      if (next is AuthLoadedSuccessfuly) {
        ToastUtils.showToast(lng?.emailVerificationLink ?? '');
      } else if (next is AuthError) {
        var error = next.error;

        ToastUtils.showToast(error, color: Colors.red);
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: lng?.updateEmail ?? ''),
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
                      title: lng?.newEmail ?? '',

                      formKey: emailKey,
                      isObscure: false,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RowTextfieldWidget(
                        controller: passController,
                        title: lng?.password ?? '',
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
                  : Text(
                    AppLocalizations.of(context)?.updateEmail ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
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
