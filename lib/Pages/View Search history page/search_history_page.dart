import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/Search%20history%20stream%20riverpd/search_history_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/search_history.dart';
import 'package:pix_hunt_project/Widgets/custom_sliver_appbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewSearchHistoryPage extends StatelessWidget {
  const ViewSearchHistoryPage({super.key});

  static const pageName = '/search_history_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(title: 'Search history'),

            SliverToBoxAdapter(
              child: Center(
                child: Consumer(
                  builder: (context, ref, child) {
                    var myRef = ref.watch(searchHistoryStreamProvider);
                    return myRef.when(
                      data: (data) => _data(data),
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => _loading(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _data(List<SearchHistory> data) {
    return (data.isEmpty)
        ? Padding(
          padding: EdgeInsets.only(top: 400),
          child: const Text(
            'No search history',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
        )
        : ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.length,
          reverse: true,
          itemBuilder: (context, index) {
            var searchHistory = data[index];
            return ListTile(
              leading: Icon(Icons.search),
              title: Text(searchHistory.title),
              trailing: Consumer(
                builder: (context, ref, child) {
                  return IconButton(
                    onPressed: () {
                      ref
                          .read(userDbProvider.notifier)
                          .removeSearchHistory(searchHistory);
                    },
                    icon: Icon(Icons.close),
                  );
                },
              ),
            );
          },
        );
  }
}

Widget _loading() {
  return Skeletonizer(
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: List.generate(50, (index) => '').length,
      reverse: true,
      itemBuilder: (context, index) {
        // var searchHistory= data[index];
        return ListTile(
          leading: Icon(Icons.search),
          title: Text('searchHistory.title'),
          trailing: Icon(Icons.close),
        );
      },
    ),
  );
}
