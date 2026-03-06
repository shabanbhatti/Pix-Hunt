import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/api%20controller/api_riverpod.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/constants/constant_static_hintcetagory_list.dart';

class TopCetagoriesWidget extends ConsumerWidget {
  const TopCetagoriesWidget({super.key, required this.titleNotifier});
  final ValueNotifier<String> titleNotifier;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('TITLE: ${titleNotifier.value}');
    return Wrap(
      children:
          ConstantStaticHintCategoryList.allProducts(context).map((e) {
            return Padding(
              padding: const EdgeInsetsGeometry.symmetric(
                horizontal: 5,
                vertical: 10,
              ),
              child: ValueListenableBuilder(
                valueListenable: titleNotifier,
                builder: (context, value, child) {
                  return GestureDetector(
                    onTap: () {
                      titleNotifier.value = e.title;
                      ref
                          .read(apiProvider.notifier)
                          .fetchData(search: e.title, pageNumber: 1);
                    },
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color:
                            (value == e.title) ? ConstantColors.appColor : null,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        border: Border.all(
                          color:
                              (value == e.title)
                                  ? ConstantColors.appColor
                                  : Colors.grey,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsGeometry.symmetric(
                          horizontal: 7,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e.title,
                              style:
                                  (value == e.title)
                                      ? const TextStyle(color: Colors.white)
                                      : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
    );
  }
}
