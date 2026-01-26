import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pix_hunt_project/Controllers/APi%20Riverpod/api_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/search_history.dart';

import 'package:pix_hunt_project/Widgets/custom_text_field.dart';

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
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      toolbarHeight: 80,

      pinned: true,
      leading: const SizedBox(),

      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
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
                            label: 'Search',
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
                    Expanded(
                      flex: 5,
                      child:
                          (isBottomNaviSearchPage == false)
                              ? IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  CupertinoIcons.xmark_circle,
                                  size: 35,
                                ),
                              )
                              : const SizedBox(),
                    ),
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
