import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/APi%20Riverpod/api_riverpod.dart';
import 'package:pix_hunt_project/Models/pexer.dart';

class PhotoPagesWidget extends StatelessWidget {
  const PhotoPagesWidget({
    super.key,
    required this.title,
    required this.pexer,
    required this.scrollController,
  });

  final Pexer pexer;
  final String title;
  final ScrollController scrollController;

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
                          .fetchApi(search: title, pageNumber: 4);
                    } else if (pexer.page == 4) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchApi(search: title, pageNumber: 3);
                    } else if (pexer.page == 3) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchApi(search: title, pageNumber: 2);
                    } else if (pexer.page == 2) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchApi(search: title, pageNumber: 1);
                    }
                    scrollController.animateTo(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_circle_left,
                    size: 40,
                    color: Colors.indigo,
                  ),
                );
              },
            )
            : const SizedBox(height: 10, width: 50),

        Text(pexer.page.toString(), style: const TextStyle(fontSize: 20)),

        Consumer(
          builder: (context, apiProviderREF, child) {
            return (pexer.page != 5)
                ? IconButton(
                  onPressed: () {
                    if (pexer.page == 1) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchApi(search: title, pageNumber: 2);
                    } else if (pexer.page == 2) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchApi(search: title, pageNumber: 3);
                    } else if (pexer.page == 3) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchApi(search: title, pageNumber: 4);
                    } else if (pexer.page == 4) {
                      apiProviderREF
                          .read(apiProvider.notifier)
                          .fetchApi(search: title, pageNumber: 5);
                    }

                    scrollController.animateTo(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: Icon(
                    Icons.arrow_circle_right,
                    size: 40,
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
