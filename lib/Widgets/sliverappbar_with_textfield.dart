import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pix_hunt_project/Controllers/APi%20Riverpod/api_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/search_history.dart';

import 'package:pix_hunt_project/Widgets/custom_text_field.dart';

class SliverappbarWithTextField extends StatelessWidget {
  const SliverappbarWithTextField({super.key, required this.controller, required this.focusNode, required this.isBottomNaviSearchPage});

final bool isBottomNaviSearchPage;
final TextEditingController controller;
final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      toolbarHeight: 80,
      floating: true,
      snap: true,
      leading: const SizedBox(),

      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.indigo,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 4,
                      child:
                          (isBottomNaviSearchPage == false)
                              ? IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: Colors.white,
                                ),
                              )
                              : const SizedBox(),
                    ),
                    Expanded(
                      flex: 30,
                      child: Consumer(
                        builder: (context, apiProviderRef, child) {
                          return MyTextField(
                            controller: controller,
                            focusNode: focusNode,
                            label: 'Search',
                            prefixIcon: Icons.search,
                            onSubmitted: (p0) {
                              String id =
                                  DateTime.now().microsecondsSinceEpoch
                                      .toString();
                              apiProviderRef
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
                            },
                          );
                        },
                      ),
                    ),
                    const Spacer(flex: 2),
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