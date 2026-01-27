import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix_hunt_project/Utils/toast.dart';

import 'package:pix_hunt_project/providers/app_provider_objects.dart';
import 'package:pix_hunt_project/repository/cloud_db_repository.dart';

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
  ImageCropper imageCropper = ImageCropper();

  Future<void> getImage() async {
    try {
      state = LoadingState();
      var getUserImg = await cloudDbRepository.getUserImage();

      state = LoadedState(imgPathUrl: getUserImg);
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

  Future<void> insertImage(File imgPathFile) async {
    try {
      state = LoadingState();

      await cloudDbRepository.userImage(imgPathFile);

      await getImage();
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

  const LoadedState({required this.imgPathUrl});
}

class ErrorState extends UserImageState {
  final String error;
  const ErrorState({required this.error});
}
