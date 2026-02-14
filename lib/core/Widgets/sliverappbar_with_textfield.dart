import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pix_hunt_project/Controllers/api%20Riverpod/api_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/search_history.dart';

import 'package:pix_hunt_project/core/Widgets/custom_search_text_field.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class SliverappbarWithTextField extends StatelessWidget {
  const SliverappbarWithTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isBottomNaviSearchPage,
    required this.searchKeyword,
    required this.isForSearchPage,
    this.animationController,
  });

  final bool isBottomNaviSearchPage;
  final AnimationController? animationController;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueNotifier<String> searchKeyword;
  final bool isForSearchPage;

  @override
  Widget build(BuildContext context) {
    print('SLIVER APP BAR CALLED');
    return CupertinoSliverNavigationBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // toolbarHeight: 140,

      // pinned: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(CupertinoIcons.back),
      ),
      largeTitle: Text(
        (isBottomNaviSearchPage)
            ? AppLocalizations.of(context)?.favourite ?? ''
            : AppLocalizations.of(context)?.search ?? '',
      ),

      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 40),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 30,
                      child: Consumer(
                        builder: (context, apiProviderRef, child) {
                          return MyTextField(
                            controller: controller,
                            focusNode: focusNode,
                            label: AppLocalizations.of(context)!.search,
                            prefixIcon: Icons.search,
                            onSubmitted: (p0) async {
                              if (isForSearchPage) {
                                if (controller.text.isNotEmpty) {
                                  searchKeyword.value = p0;
                                  String id =
                                      DateTime.now().microsecondsSinceEpoch
                                          .toString();
                                  await apiProviderRef
                                      .read(apiProvider.notifier)
                                      .fetchApi(
                                        search: controller.text,
                                        pageNumber: 1,
                                      )
                                      .then((value) {
                                        print('SEARCHED HISTORY DB CALLED');
                                        apiProviderRef
                                            .read(userDbProvider.notifier)
                                            .addSearchHistory(
                                              SearchHistory(
                                                title: controller.text,
                                                id: id,
                                              ),
                                            );
                                      });

                                  animationController?.forward();
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
