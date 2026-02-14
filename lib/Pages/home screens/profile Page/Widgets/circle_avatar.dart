import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/User_Image_riverpod.dart/user_img_riverpod.dart';
import 'package:pix_hunt_project/Pages/home%20screens/View%20User%20Image%20page/view_user_img_page.dart';
import 'package:pix_hunt_project/core/Utils/extensions.dart';
import 'package:pix_hunt_project/core/Utils/image_picker_utils.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/Widgets/View%20user%20image%20bottom%20sheet/user_img_bottom_sheet.dart';

import 'package:pix_hunt_project/services/shared_preference_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CircleAvatarWidget extends ConsumerStatefulWidget {
  const CircleAvatarWidget({super.key});

  @override
  ConsumerState<CircleAvatarWidget> createState() => _CircleAvatarWidgetState();
}

class _CircleAvatarWidgetState extends ConsumerState<CircleAvatarWidget> {
  late ValueNotifier<String> usernameNotifier = ValueNotifier('No Username');

  @override
  void initState() {
    super.initState();

    getUsername();
  }

  void getUsername() async {
    var username = await SpService.getString('username');
    usernameNotifier.value = username ?? 'No Username';
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userImgProvider, (previous, next) {
      if (next is ErrorState) {
        ToastUtils.showToast(next.error, color: Colors.red);
      }
    });
    return Consumer(
      builder: (context, ref, child) {
        var myRef = ref.watch(userImgProvider);
        if (myRef is LoadingState) {
          return _loading();
        } else if (myRef is LoadedState) {
          return _circleAvatarWidget(
            context,
            imgPath: myRef.imgPathUrl,
            nameInitialNotifier: usernameNotifier,
            onInsertImage: (file) {
              ref.read(userImgProvider.notifier).insertImage(file);
            },
            onChangePic: (file) {
              ref.read(userImgProvider.notifier).insertImage(file);
            },
            onRemovePic: () {
              ref.read(userImgProvider.notifier).deleteImage();
            },
          );
        } else {
          return GestureDetector(
            onTap: () async {
              var file = await ImagePickerUtils.pickImage();
              if (file != null) {
                ref.read(userImgProvider.notifier).insertImage(file);
              }
            },
            child: const Text('data'),
          );
        }
      },
    );
  }
}

Widget _loading() {
  return Center(
    child: ClipOval(
      child: Skeletonizer(
        enabled: true,
        child: Container(color: Colors.grey[300], height: 150, width: 150),
      ),
    ),
  );
}

Widget _circleAvatarWidget(
  BuildContext context, {
  required String imgPath,
  required void Function(File file) onInsertImage,
  required ValueNotifier<String> nameInitialNotifier,
  required void Function(File file) onChangePic,
  required void Function() onRemovePic,
}) {
  return Padding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
    child: Container(
      height: 120,
      width: 120,

      child: Stack(
        children: [
          Hero(
            tag: 'user_image',
            child: Container(
              height: 120,
              width: 120,

              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color:
                    (imgPath.isEmpty)
                        ? Colors.pink
                        : Colors.grey.withAlpha(100),
              ),
              alignment: Alignment.center,
              child:
                  (imgPath.isEmpty)
                      ? ValueListenableBuilder(
                        valueListenable: nameInitialNotifier,
                        builder: (context, value, child) {
                          return Text(
                            value.initials,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.white,
                            ),
                          );
                        },
                      )
                      : GestureDetector(
                        onLongPress: () {
                          Navigator.pushNamed(
                            context,
                            ViewUserImgPage.pageName,
                            arguments:
                                {'imgUrl': imgPath} as Map<String, dynamic>,
                          );
                        },
                        onTap: () {
                          showUserImageOptionsSheet(
                            context,
                            open: () {
                              Navigator.pop(context);
                              Navigator.of(context).pushNamed(
                                ViewUserImgPage.pageName,
                                arguments:
                                    {'imgUrl': imgPath} as Map<String, dynamic>,
                              );
                            },
                            changePic: () async {
                              var file = await ImagePickerUtils.pickImage();
                              if (file != null) {
                                onChangePic(file);
                              }
                              Navigator.pop(context);
                            },
                            remove: () {
                              onRemovePic();
                              Navigator.pop(context);
                            },
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: imgPath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorWidget: (context, url, error) {
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsetsGeometry.all(0),
              child: GestureDetector(
                onTap: () async {
                  var file = await ImagePickerUtils.pickImage();
                  if (file != null) {
                    onInsertImage(file);
                  }
                },
                child: Builder(
                  builder: (contextx) {
                    return CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          Theme.of(contextx).scaffoldBackgroundColor,
                      child: Icon(
                        CupertinoIcons.camera_fill,
                        color: Theme.of(contextx).primaryColor,
                        size: 22,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
