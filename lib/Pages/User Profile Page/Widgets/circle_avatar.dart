import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/User_Image_riverpod.dart/user_img_riverpod.dart';
import 'package:pix_hunt_project/Pages/View%20User%20Image%20page/view_user_img_page.dart';
import 'package:pix_hunt_project/Utils/constant_mgs.dart';
import 'package:pix_hunt_project/Widgets/View%20user%20image%20bottom%20sheet/user_img_bottom_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CircleAvatarWidget extends ConsumerStatefulWidget {
  const CircleAvatarWidget({super.key});

  @override
  ConsumerState<CircleAvatarWidget> createState() => _CircleAvatarWidgetState();
}

class _CircleAvatarWidgetState extends ConsumerState<CircleAvatarWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userImgProvider.notifier).getImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('CIRCLE AVATAR DRAWER BUILD CALLED');
    return Hero(
      tag: 'user_image',
      child: ClipOval(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Material(
          shape: CircleBorder(),
          child: Container(
            color: Colors.grey.withAlpha(80),
            height: 150,
            width: 150,
            child: Consumer(
              builder: (context, ref, child) {
                // var streamRef = ref.watch(userDocStreamProvider);
                var myRef = ref.watch(userImgProvider);
                if (myRef is LoadingState) {
                  return _loading();
                } else if (myRef is LoadedState) {
                  return _data(myRef.imgPath, myRef.imgPathUrl);
                } else {
                  return InkWell(
                    onTap: () {
                      ref.read(userImgProvider.notifier).pickImage();
                    },
                    child: Icon(
                      CupertinoIcons.camera_fill,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _data(String imgPath, String imgUrl) {
    return InkWell(
      onLongPress: () {
        Navigator.pushNamed(
          context,
          ViewUserImgPage.pageName,
          arguments:
              {'imgUrl': imgUrl, 'imgPath': imgPath} as Map<String, dynamic>,
        );
      },
      onTap: () {
        if (imgUrl == '') {
          ref.read(userImgProvider.notifier).pickImage();
        } else {
          showUserImageOptionsSheet(
            context,
            open: () {
              Navigator.of(context)
                  .pushNamed(
                    ViewUserImgPage.pageName,
                    arguments:
                        {'imgUrl': imgUrl, 'imgPath': imgPath}
                            as Map<String, dynamic>,
                  )
                  .then((value) {
                    Navigator.pop(context);
                  });
            },
            changePic: () {
              ref.read(userImgProvider.notifier).pickImage();
              Navigator.pop(context);
            },
            remove: () {
              ref.read(userImgProvider.notifier).deleteImage();
              Navigator.pop(context);
            },
          );
        }
      },
      child:
          (imgUrl == '')
              ? Image.asset(user_img)
              : CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.cover,
                progressIndicatorBuilder:
                    (context, url, progress) => _loading(),
              ),
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
