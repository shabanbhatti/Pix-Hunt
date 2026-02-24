import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/api%20controller/api_riverpod.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';

class SearchPhotosPagesWidget extends StatelessWidget {
  const SearchPhotosPagesWidget({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.pexer,
  });

  final TextEditingController controller;
  final ScrollController scrollController;
  final Pexer pexer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (pexer.page != 1)
            ? Consumer(
              builder: (context, apiProviderREF, child) {
                return IconButton(
                  onPressed: () {
                    if (pexer.page == 5) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchData(search: controller.text, pageNumber: 4);
                    } else if (pexer.page == 4) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchData(search: controller.text, pageNumber: 3);
                    } else if (pexer.page == 3) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchData(search: controller.text, pageNumber: 2);
                    } else if (pexer.page == 2) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchData(search: controller.text, pageNumber: 1);
                    }

                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_circle_left,
                    size: 30,
                    color: Colors.indigo,
                  ),
                );
              },
            )
            : const SizedBox(height: 10, width: 50),

        Text(
          pexer.page.toString(),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),

        Consumer(
          builder: (context, apiProviderREF, child) {
            return (pexer.page != 5)
                ? IconButton(
                  onPressed: () {
                    if (pexer.page == 1) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchData(search: controller.text, pageNumber: 2)
                          .then((value) {
                            scrollController.animateTo(
                              0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                    } else if (pexer.page == 2) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchData(search: controller.text, pageNumber: 3);
                    } else if (pexer.page == 3) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchData(search: controller.text, pageNumber: 4);
                    } else if (pexer.page == 4) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchData(search: controller.text, pageNumber: 5);
                    }

                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_circle_right,
                    size: 30,
                    color: Colors.indigo,
                  ),
                )
                : const SizedBox(height: 10, width: 50);
          },
        ),
      ],
    );
  }
}
