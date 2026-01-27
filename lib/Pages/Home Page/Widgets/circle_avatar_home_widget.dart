import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/User_Image_riverpod.dart/user_img_riverpod.dart';
import 'package:pix_hunt_project/Utils/constant_mgs.dart';
import 'package:pix_hunt_project/Utils/extensions.dart';
import 'package:pix_hunt_project/services/shared_preference_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CircleAvatarHomeWidget extends ConsumerStatefulWidget {
  const CircleAvatarHomeWidget({super.key});

  @override
  ConsumerState<CircleAvatarHomeWidget> createState() =>
      _CircleAvatarWidgetState();
}

class _CircleAvatarWidgetState extends ConsumerState<CircleAvatarHomeWidget> {
  ValueNotifier<String> usernameNotifier = ValueNotifier('');
  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  Future<void> loadUsername() async {
    var name = await SpService.getString('username');
    usernameNotifier.value = name ?? '';
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
              color: Colors.pink,
              height: 40,
              width: 40,
              alignment: Alignment.center,
              child: Consumer(
                builder: (context, ref, child) {
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
        ? ValueListenableBuilder(
          valueListenable: usernameNotifier,
          builder: (context, value, child) {
            return Text(
              value.initials,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            );
          },
        )
        : CachedNetworkImage(
          imageUrl: imgUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
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
