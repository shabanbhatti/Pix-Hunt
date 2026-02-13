import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_state.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Pages/home%20screens/update%20email%20page/Widgets/row_textfield_widget.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20btns/app_main_btn.dart';
import 'package:pix_hunt_project/core/Widgets/custom_sliver_appbar.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';
import 'package:pix_hunt_project/services/shared_preference_service.dart';

class UpdateNamePage extends ConsumerStatefulWidget {
  const UpdateNamePage({super.key});
  static const pageName = '/update_name';

  @override
  ConsumerState<UpdateNamePage> createState() => _UpdateNamePageState();
}

class _UpdateNamePageState extends ConsumerState<UpdateNamePage> {
  TextEditingController nameController = TextEditingController();

  GlobalKey<FormState> nameKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getName();
  }

  void getName() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var userDb = ref.watch(userDbProvider);

      if (userDb is LoadedSuccessfulyUserDb) {
        var name = userDb.auth.name ?? '';
        nameController.text = name;
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('UPDATE name BUILD CALLED');
    var lng = AppLocalizations.of(context);
    ref.listen(authProvider('update_name'), (previous, next) {
      if (next is AuthLoadedSuccessfuly) {
        ToastUtils.showToast(lng?.nameUpdatedSuccessfully ?? '');
        Navigator.pop(context);
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: lng?.updateName ?? ''),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    RowTextfieldWidget(
                      controller: nameController,
                      title: lng?.name ?? '',

                      formKey: nameKey,
                      isObscure: false,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 40),
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
        var myRef = ref.watch(authProvider('update_name'));
        return AppMainBtn(
          widgetOrTitle: WidgetOrTitle.widget,
          btnValueWidget:
              (myRef is AuthLoading)
                  ? CupertinoActivityIndicator(color: Colors.white)
                  : Text(
                    AppLocalizations.of(context)?.updateName ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
          onTap: () async {
            var nameValidate = nameKey.currentState!.validate();

            if (nameValidate) {
              await ref
                  .read(authProvider('update_name').notifier)
                  .updateName(nameController.text);
              await ref.read(userDbProvider.notifier).fetchUserDbData();
              await SpService.setString('username', nameController.text.trim());
            }
          },
        );
      },
    );
  }
}
