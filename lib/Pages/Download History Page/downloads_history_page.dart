import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pix_hunt_project/Controllers/Downloads%20Stream%20RIverpod/download_stream_riv.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';

import 'package:pix_hunt_project/Pages/Download%20History%20Page/Widgets/list_tile.dart';
import 'package:pix_hunt_project/Pages/View%20Downloaded%20Item%20page/view_downloaded_item.dart';
import 'package:pix_hunt_project/Widgets/custom_dialog_boxes.dart';
import 'package:pix_hunt_project/Widgets/custom_show_bottom_sheets.dart';
import 'package:pix_hunt_project/Widgets/custom_sliver_appbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DownloadHistoryPage extends StatelessWidget {
  const DownloadHistoryPage({super.key});
  static const pageName = '/download_history_page';

  String myDate(String date) {
    DateTime dateTime = DateTime.parse(date);

    var dateFormat = DateFormat.yMMMd().format(dateTime);
    return dateFormat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(title: 'Downloads'),
            SliverToBoxAdapter(
              child: Center(
                child: Consumer(
                  builder: (context, ref, child) {
                    var myRef = ref.watch(downloadHistoryStreamProvider);
                    return myRef.when(
                      data: (data) {
                        return (data.isEmpty)
                            ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 300),
                              child: Text(
                                'No Downloads',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return CustomListTile1(
                                  imgUrl: data[index].imgUrl,
                                  date: myDate(data[index].date.toString()),

                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      ViewDownloadedItem.pageName,
                                      arguments: data[index],
                                    );
                                  },
                                  onLongTap: () {
                                    customBottomSheet(
                                      context,
                                      open: () {
                                        Navigator.of(context).pushNamed(
                                          ViewDownloadedItem.pageName,
                                          arguments: data[index],
                                        );
                                      },
                                      delete: () {
                                        print(
                                          '--------UI DELETE CALLED---------',
                                        );
                                        deleteDialogBox(context, () {
                                          ref
                                              .read(userDbProvider.notifier)
                                              .deleteDownloadedHistory(
                                                data[index],
                                              );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      },
                                    );
                                  },
                                  photographer:
                                      '${data[index].photographer}\n [${data[index].pixels}]',
                                  title: data[index].title,
                                );
                              },
                            );
                      },
                      error: (error, stackTrace) {
                        return Text('$error');
                      },
                      loading: () {
                        return _loading();
                      },
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
}

Widget _loading() {
  return Skeletonizer(
    enabled: true,
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: List.generate(50, (index) => '').length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Skeletonizer(
            enabled: true,
            child: Container(
              width: 80,
              height: 80,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(100),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          title: Text('Hi there is a downliad histry page'),
          subtitle: Text('Photographer \n  (2000 Pizels)'),
        );
      },
    ),
  );
}
