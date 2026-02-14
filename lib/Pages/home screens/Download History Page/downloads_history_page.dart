import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/Downloads%20Stream%20RIverpod/download_stream_riv.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Pages/home%20screens/Download%20History%20Page/Widgets/list_tile.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20Downloaded%20Item%20page/view_downloaded_item.dart';
import 'package:pix_hunt_project/core/Utils/date_format_util.dart';
import 'package:pix_hunt_project/core/Widgets/custom_dialog_boxes.dart';
import 'package:pix_hunt_project/core/Widgets/custom_show_bottom_sheets.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DownloadHistoryPage extends ConsumerStatefulWidget {
  const DownloadHistoryPage({super.key});
  static const pageName = '/download_history_page';

  @override
  ConsumerState<DownloadHistoryPage> createState() =>
      _DownloadHistoryPageState();
}

class _DownloadHistoryPageState extends ConsumerState<DownloadHistoryPage>
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
    log('Download history page build called');
    var lng = AppLocalizations.of(context);
    ref.listen(downloadHistoryStreamProvider, (previous, next) {
      if (next.hasValue) {
        animationController.forward();
      }
    });
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_new_outlined),
              ),
              largeTitle: Text(
                lng?.downloadHistory ?? '',
                style: const TextStyle(),
              ),
              trailing: GestureDetector(
                onTap: () {
                  EasyLoading.show(
                    indicator: CupertinoActivityIndicator(color: Colors.white),
                    status: 'Clearing all history...',
                    dismissOnTap: false,
                  );
                  ref
                      .read(userDbProvider.notifier)
                      .deleteAllDownloadedHistory();

                  EasyLoading.dismiss();
                },
                child: Text(
                  lng?.clearAll ?? '',
                  style: TextStyle(color: Colors.indigo),
                ),
              ),
            ),
            SliverSafeArea(
              top: false,
              sliver: Consumer(
                builder: (context, ref, child) {
                  var myRef = ref.watch(downloadHistoryStreamProvider);
                  return myRef.when(
                    data: (x) {
                      var data = x.reversed.toList();
                      return (data.isEmpty)
                          ? SliverFillRemaining(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.download),
                                  Text(
                                    ' ${lng?.noDownloads ?? ''}',

                                    style: TextStyle(
                                      // color: Colors.indigo,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : SliverList.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
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
                                child: CustomListTile1(
                                  imgUrl: data[index].imgUrl,
                                  date: DateFormatUtil.dateFormat(
                                    data[index].date.toString(),
                                  ),

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
                                        Navigator.pop(context);
                                        Navigator.of(context).pushNamed(
                                          ViewDownloadedItem.pageName,
                                          arguments: data[index],
                                        );
                                      },
                                      delete: () {
                                        Navigator.pop(context);
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
                                ),
                              );
                            },
                          );
                    },
                    error: (error, stackTrace) {
                      return SliverFillRemaining(
                        child: Center(child: Text('$error')),
                      );
                    },
                    loading: () {
                      return _loading();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _loading() {
  return SliverList.builder(
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
  );
}
