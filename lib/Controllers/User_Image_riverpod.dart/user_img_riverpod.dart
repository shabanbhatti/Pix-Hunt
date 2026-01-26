import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix_hunt_project/Utils/toast.dart';

import 'package:pix_hunt_project/providers/app_provider_objects.dart';
import 'package:pix_hunt_project/repository/cloud_db_repository.dart';
import 'package:pix_hunt_project/services/shared_preference_service.dart';

final userImgProvider =
    StateNotifierProvider<UserImageNotifier, UserImageState>((ref) {
      return UserImageNotifier(
        cloudDbRepository: ref.read(cloudDbRepositoryProviderObject),
      );
    });

class UserImageNotifier extends StateNotifier<UserImageState> {
  final CloudDbRepository cloudDbRepository;
  UserImageNotifier({required this.cloudDbRepository}) : super(InitialState());

  ImagePicker imagePicker = ImagePicker();

  Future<void> getImage() async {
    try {
      state = LoadingState();
      var getUserImg = await cloudDbRepository.getUserImage();

      log(getUserImg);
      if (getUserImg != '') {
        await SpService.setString(SpService.userImgKEY, getUserImg);
      }

      var image = await SpService.getString(SpService.userImgKEY) ?? '';

      if (image == '' || image.isEmpty) {
        print('NULL');
        state = LoadedState(imgPathUrl: '', imgPath: '');
      } else {
        print('NON NULL');
        state = LoadedState(imgPathUrl: image, imgPath: '');
      }
    } catch (e) {
      log(e.toString());
      state = ErrorState(error: e.toString());
    }
  }

  Future<void> deleteImage() async {
    try {
      await cloudDbRepository.deleteUserImage();
      await getImage();
    } catch (e) {
      log('$e');
    }
  }

  Future<void> pickImage() async {
    try {
      state = LoadingState();
      var result = await imagePicker.pickImage(source: ImageSource.gallery);

      if (result != null) {
        final file = File(result.path);

        await cloudDbRepository.userImage(file);

        await getImage();
      } else {
        await getImage();
      }
    } catch (e) {
      ToastUtils.showToast(e.toString(), color: Colors.red);
    }
  }
}

sealed class UserImageState {
  const UserImageState();
}

class InitialState extends UserImageState {
  const InitialState();
}

class LoadingState extends UserImageState {
  const LoadingState();
}

class LoadedState extends UserImageState {
  final String imgPathUrl;
  final String imgPath;

  const LoadedState({required this.imgPath, required this.imgPathUrl});
}

class ErrorState extends UserImageState {
  final String error;
  const ErrorState({required this.error});
}
