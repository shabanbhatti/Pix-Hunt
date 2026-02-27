import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20controller/user_db_riverpod.dart';
import 'package:pix_hunt_project/Pages/home%20screens/change%20password%20page/change_password_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/setting%20page/widgets/delete_account_widget.dart';
import 'package:pix_hunt_project/Pages/initial%20screens/Login%20Page/login_page.dart';
import 'package:pix_hunt_project/core/Utils/bottom%20sheets/half_size_bottom_sheet_util.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/Widgets/custom_listtile_widget.dart';
import 'package:pix_hunt_project/Pages/home%20screens/update%20email%20page/update_email_page.dart';
import 'package:pix_hunt_project/Pages/home%20screens/update%20name%20page/update_name_page.dart';
import 'package:pix_hunt_project/core/Widgets/custom_sliver_appbar.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});
  static const String pageName = "/setting_page";
  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale1;
  late Animation<double> fade1;
  late Animation<double> scale2;
  late Animation<double> fade2;
  late Animation<double> scale3;
  late Animation<double> fade3;
  late Animation<double> scale4;
  late Animation<double> fade4;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    fade1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.25),
      ),
    );

    scale1 = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.25),
      ),
    );

    fade2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.25, 0.50),
      ),
    );

    scale2 = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.25, 0.50),
      ),
    );

    fade3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.50, 0.75),
      ),
    );

    scale3 = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.50, 0.75),
      ),
    );

    fade4 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.75, 1.0),
      ),
    );

    scale4 = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.75, 1.0),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward();
    });
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lng = AppLocalizations.of(context);
    ref.listen(userDbProvider, (previous, next) {
      if (next is LoadingUserDb) {
        EasyLoading.show();
      }
      if (next is ErrorUserDb) {
        EasyLoading.dismiss();
        ToastUtils.showToast(next.error, color: Colors.red);
      }
      if (next is AccountDeleteUserDb) {
        EasyLoading.dismiss();
        ToastUtils.showToast(lng?.account_deleted_success ?? '');
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(LoginPage.pageName, (route) => false);
      }
    });
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            CustomSliverAppBar(title: lng?.settings ?? ''),
            SliverPadding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: scale1,
                      child: FadeTransition(
                        opacity: fade1,
                        child: CustomListTileWidget(
                          leading: Icons.email,
                          title: AppLocalizations.of(context)!.updateEmail,
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(UpdateEmailPage.pageName);
                          },
                        ),
                      ),
                    ),
                    ScaleTransition(
                      scale: scale2,
                      child: FadeTransition(
                        opacity: fade2,
                        child: CustomListTileWidget(
                          leading: Icons.person,
                          title: AppLocalizations.of(context)!.updateName,
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(UpdateNamePage.pageName);
                          },
                        ),
                      ),
                    ),
                    ScaleTransition(
                      scale: scale3,
                      child: FadeTransition(
                        opacity: fade3,
                        child: CustomListTileWidget(
                          leading: Icons.lock,
                          title: AppLocalizations.of(context)!.changePassword,
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(ChangePasswordPage.pageName);
                          },
                        ),
                      ),
                    ),
                    ScaleTransition(
                      scale: scale4,
                      child: FadeTransition(
                        opacity: fade4,
                        child: CustomListTileWidget(
                          leading: Icons.delete,
                          color: Colors.red,
                          title: lng?.delete_account ?? '',
                          onTap: () {
                            openHalfBottomSheet(
                              context,
                              child: const DeleteAccountWidget(),
                              size: 0.8,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
