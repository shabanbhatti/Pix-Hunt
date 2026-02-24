import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';

abstract class ImagePickerUtils {
  static Future<File?> pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    ImageCropper imageCropper = ImageCropper();
    var result = await imagePicker.pickImage(source: ImageSource.gallery);

    if (result == null) return null;

    final croppedFile = await imageCropper.cropImage(
      sourcePath: result.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: ConstantColors.appColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: false),
      ],
    );
    if (croppedFile != null) {
      File file = File(croppedFile.path);
      return file;
    } else {
      return null;
    }
  }
}
