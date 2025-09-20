import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/User_Image_riverpod.dart/user_img_riverpod.dart';
import 'package:pix_hunt_project/Utils/constant_mgs.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CircleAvatarHomeWidget extends ConsumerStatefulWidget {
  const CircleAvatarHomeWidget({super.key});

  @override
  ConsumerState<CircleAvatarHomeWidget> createState() =>
      _CircleAvatarWidgetState();
}

class _CircleAvatarWidgetState extends ConsumerState<CircleAvatarHomeWidget> {
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
      child: CircleAvatar(
        radius: 10,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Material(
            shape: const CircleBorder(),
            child: Container(
              color: Colors.indigo,
              height: 40,
              width: 40,
              child: Consumer(
                builder: (context, ref, child) {
                  // var streamRef = ref.watch(userDocStreamProvider);
                  var myRef = ref.watch(userImgProvider);
                  if (myRef is LoadingState) {
                    return _loading();
                  } else if (myRef is LoadedState) {
                    return _data(myRef.imgPathUrl);
                  } else {
                    return Image.asset(user_img);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _data(String imgUrl) {
    return (imgUrl == '')
        ? Image.asset(user_img)
        : CachedNetworkImage(
          imageUrl: imgUrl,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) => _loading(),
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
