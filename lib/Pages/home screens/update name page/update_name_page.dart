import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20controller/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20controller/auth_state.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20controller/user_db_riverpod.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/Utils/validations_textfields_utils.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20btns/app_main_btn.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20textfields/custom_textfield_widget.dart';
import 'package:pix_hunt_project/core/Widgets/custom_sliver_appbar.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/constants/constants_sharedPref_keys.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';
import 'package:pix_hunt_project/core/services/shared_preference_service.dart';

class UpdateNamePage extends ConsumerStatefulWidget {
  const UpdateNamePage({super.key});
  static const pageName = '/update_name';

  @override
  ConsumerState<UpdateNamePage> createState() => _UpdateNamePageState();
}

class _UpdateNamePageState extends ConsumerState<UpdateNamePage>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode nameFocusNode = FocusNode();
  FocusNode btnFocusNode = FocusNode();
  late AnimationController animationController;
  late Animation<double> scaleNameField;
  late Animation<double> fadeNameField;
  late Animation<double> scaleUpdateNameDetail;
  late Animation<double> fadeUpdateNameDetail;
  late Animation<double> scaleUpdateBtn;
  late Animation<double> fadeUpdateBtn;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    fadeNameField = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.3),
      ),
    );

    scaleNameField = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.3),
      ),
    );

    fadeUpdateNameDetail = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 0.6),
      ),
    );

    scaleUpdateNameDetail = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 0.6),
      ),
    );

    fadeUpdateBtn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 1.0),
      ),
    );

    scaleUpdateBtn = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 1.0),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward();
    });
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
    animationController.dispose();
    nameFocusNode.dispose();
    btnFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Update name build called');
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
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: scaleNameField,
                        child: FadeTransition(
                          opacity: fadeNameField,
                          child: CustomTextfieldWidget(
                            controller: nameController,
                            focusNode: nameFocusNode,
                            label: lng?.updateName ?? '',
                            prefixIcon: Icons.person,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(btnFocusNode);
                            },
                            validator:
                                (v) =>
                                    ValidationsTextfieldsUtils.nameValidation(
                                      v,
                                      context,
                                    ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 10, top: 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ScaleTransition(
                            scale: scaleUpdateNameDetail,
                            child: FadeTransition(
                              opacity: fadeUpdateNameDetail,
                              child: Text(
                                '*${lng?.updateNameBtnDetail ?? ''}',
                                style: TextStyle(
                                  fontSize: 12,

                                  color: ConstantColors.appColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          var myRef = ref.watch(authProvider('update_name'));
                          return ScaleTransition(
                            scale: scaleUpdateBtn,
                            child: FadeTransition(
                              opacity: fadeUpdateBtn,
                              child: AppMainBtn(
                                focusNode: btnFocusNode,
                                widgetOrTitle: WidgetOrTitle.widget,
                                btnValueWidget:
                                    (myRef is AuthLoading)
                                        ? CupertinoActivityIndicator(
                                          color: Colors.white,
                                        )
                                        : Text(
                                          AppLocalizations.of(
                                                context,
                                              )?.updateName ??
                                              '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                onTap:
                                    (myRef is AuthLoading)
                                        ? () {}
                                        : () async {
                                          var nameValidate =
                                              formKey.currentState!.validate();

                                          if (nameValidate) {
                                            var spService =
                                                getIt<
                                                  SharedPreferencesService
                                                >();
                                            await ref
                                                .read(
                                                  authProvider(
                                                    'update_name',
                                                  ).notifier,
                                                )
                                                .updateName(
                                                  nameController.text,
                                                );
                                            await ref
                                                .read(userDbProvider.notifier)
                                                .fetchUserDbData();
                                            await spService.setString(
                                              ConstantsSharedprefKeys
                                                  .usernameKey,
                                              nameController.text.trim(),
                                            );
                                          }
                                        },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
