import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/Models/downloads_image_model.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Models/search_history.dart';
import 'package:pix_hunt_project/core/Utils/img_download.dart';
import 'package:pix_hunt_project/core/errors/failures/failures.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';
import 'package:pix_hunt_project/repository/cloud_db_repository.dart';

final userDbProvider =
    StateNotifierProvider.autoDispose<UserDbStateNotifier, UserDbState>((ref) {
      return UserDbStateNotifier(cloudDbRepository: getIt<CloudDbRepository>());
    });

class UserDbStateNotifier extends StateNotifier<UserDbState> {
  CloudDbRepository cloudDbRepository;
  UserDbStateNotifier({required this.cloudDbRepository})
    : super(InitialUserDb());

  Future<void> fetchUserDbData() async {
    state = LoadingUserDb();
    try {
      var auth = await cloudDbRepository.getUserData();

      state = LoadedSuccessfulyUserDb(auth: auth);
    } on Failures catch (e) {
      state = ErrorUserDb(error: e.message);
    }
  }

  Future<void> onLogin() async {
    try {
      await cloudDbRepository.onLogin();
    } on Failures catch (e) {
      state = ErrorUserDb(error: e.message);
    }
  }

  Future<void> addFavouriteItems(Photos photos) async {
    try {
      await cloudDbRepository.addToBookmark(photos);
    } on Failures catch (e) {
      state = ErrorUserDb(error: e.message);
    }
  }

  Future<void> deleteBookmarkItem(Photos photos) async {
    try {
      await cloudDbRepository.deleteBookmark(photos);
    } on Failures catch (e) {
      state = ErrorUserDb(error: e.message);
    }
  }

  Future<ImageDownloadedMessageModel?> addDownloadedPhotos(
    DownloadsImageModel downloadImageModel,
    String downloading,
    String onSuccess,
  ) async {
    try {
      EasyLoading.show(
        status: downloading,
        indicator: const CupertinoActivityIndicator(color: Colors.grey),
      );
      await cloudDbRepository.addDownloadedPhotos(downloadImageModel);
      var data = await ImageDownloadMethodUtils.downloadImg(
        downloadImageModel.imgUrl,
        onSuccess,
      );

      EasyLoading.dismiss();
      return data;
    } on Failures catch (e) {
      EasyLoading.dismiss();
      state = ErrorUserDb(error: e.message);
      return null;
    }
  }

  Future<void> deleteDownloadedHistory(
    DownloadsImageModel downloadImageModel,
  ) async {
    try {
      await cloudDbRepository.deleteDownloadHistory(downloadImageModel);
    } on Failures catch (e) {
      state = ErrorUserDb(error: e.message);
    }
  }

  Future<void> deleteAllDownloadedHistory() async {
    try {
      await cloudDbRepository.deleteAllDownloadHistory();
    } on Failures catch (e) {
      state = ErrorUserDb(error: e.message);
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      state = LoadingUserDb();
      await cloudDbRepository.deleteAccount(password);
      state = AccountDeleteUserDb();
    } on Failures catch (e) {
      state = ErrorUserDb(error: e.message);
    }
  }

  Future<void> addSearchHistory(SearchHistory searchHistory) async {
    try {
      await cloudDbRepository.addSearchHistory(searchHistory);
    } on Failures catch (e) {
      state = ErrorUserDb(error: e.message);
    }
  }

  Future<void> removeSearchHistory(SearchHistory searchHistory) async {
    try {
      await cloudDbRepository.removerSearchHistory(searchHistory);
    } on Failures catch (e) {
      state = ErrorUserDb(error: e.message);
    }
  }
}

sealed class UserDbState {
  const UserDbState();
}

class InitialUserDb extends UserDbState {
  const InitialUserDb();
}

class LoadingUserDb extends UserDbState {
  const LoadingUserDb();
}

class LoadedSuccessfulyUserDb extends UserDbState {
  final Auth auth;

  const LoadedSuccessfulyUserDb({required this.auth});
}

class AccountDeleteUserDb extends UserDbState {
  const AccountDeleteUserDb();
}

class ErrorUserDb extends UserDbState {
  final String error;
  const ErrorUserDb({required this.error});
}
