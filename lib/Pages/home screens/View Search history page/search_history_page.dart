import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/Search%20history%20stream%20riverpd/search_history_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/search_history.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20home%20cetagory%20Page/view_page.dart';
import 'package:pix_hunt_project/core/Widgets/custom_sliver_appbar.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewSearchHistoryPage extends ConsumerStatefulWidget {
  const ViewSearchHistoryPage({super.key});

  static const pageName = '/search_history_page';

  @override
  ConsumerState<ViewSearchHistoryPage> createState() =>
      _ViewSearchHistoryPageState();
}

class _ViewSearchHistoryPageState extends ConsumerState<ViewSearchHistoryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('View search history page build called');
    ref.listen(searchHistoryStreamProvider, (previous, next) {
      if (next.hasValue) {
        animationController.forward();
      }
    });
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: AppLocalizations.of(context)!.searchHistory,
            ),

            Consumer(
              builder: (context, ref, child) {
                var myRef = ref.watch(searchHistoryStreamProvider);
                return myRef.when(
                  data: (data) => _data(data),
                  error:
                      (error, stackTrace) => SliverFillRemaining(
                        child: Center(child: Text(error.toString())),
                      ),
                  loading: () => _loading(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _data(List<SearchHistory> x) {
    var data = x.reversed.toList();
    return (data.isEmpty)
        ? SliverFillRemaining(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search),
                Text(
                  ' ${AppLocalizations.of(context)?.noSearchHistory ?? ''} ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
        : SliverList.builder(
          itemCount: data.length,

          itemBuilder: (context, index) {
            var searchHistory = data[index];
            final animation = CurvedAnimation(
              parent: animationController,
              curve: Interval(
                index / data.length,
                (index + 1) / data.length,
                curve: Curves.easeInQuart,
              ),
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ViewContentPage.pageName,
                    arguments:
                        {'record': null, 'title': '${searchHistory.title}'}
                            as Map<String, dynamic>,
                  );
                },
                leading: const Icon(Icons.search),
                title: Text(searchHistory.title),
                trailing: Consumer(
                  builder: (context, ref, child) {
                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(userDbProvider.notifier)
                            .removeSearchHistory(searchHistory);
                      },
                      child: const Icon(Icons.close),
                    );
                  },
                ),
              ),
            );
          },
        );
  }
}

Widget _loading() {
  return SliverList.builder(
    itemCount: List.generate(50, (index) => '').length,

    itemBuilder: (context, index) {
      return const Skeletonizer(
        child: ListTile(
          leading: Icon(Icons.search),
          title: Text('searchHistory.title'),
          trailing: Icon(Icons.close),
        ),
      );
    },
  );
}
