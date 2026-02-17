import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/Models/downloads_image_model.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Models/search_history.dart';
import 'package:pix_hunt_project/core/Utils/img_download.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
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
    } catch (e) {
      state = ErrorUserDb(error: e.toString());
    }
  }

  Future<void> addFavouriteItems(Photos photos) async {
    try {
      await cloudDbRepository.addToBookmark(photos);
    } catch (e) {
      state = ErrorUserDb(error: e.toString());
    }
  }

  Future<void> deleteBookmarkItem(Photos photos) async {
    try {
      await cloudDbRepository.deleteBookmark(photos);
    } catch (e) {
      state = ErrorUserDb(error: e.toString());
    }
  }

  Future<({bool isDownloade, String message})?> addDownloadedPhotos(
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
    } catch (e) {
      EasyLoading.dismiss();
      state = ErrorUserDb(error: e.toString());
      return null;
    }
  }

  Future<void> deleteDownloadedHistory(
    DownloadsImageModel downloadImageModel,
  ) async {
    try {
      await cloudDbRepository.deleteDownloadHistory(downloadImageModel);
    } catch (e) {
      state = ErrorUserDb(error: e.toString());
    }
  }

  Future<void> deleteAllDownloadedHistory() async {
    try {
      await cloudDbRepository.deleteAllDownloadHistory();
    } catch (e) {
      state = ErrorUserDb(error: e.toString());
    }
  }

  Future<void> addSearchHistory(SearchHistory searchHistory) async {
    try {
      await cloudDbRepository.addSearchHistory(searchHistory);
    } catch (e) {
      state = ErrorUserDb(error: e.toString());
    }
  }

  Future<void> removeSearchHistory(SearchHistory searchHistory) async {
    try {
      await cloudDbRepository.removerSearchHistory(searchHistory);
    } catch (e) {
      state = ErrorUserDb(error: e.toString());
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

class ErrorUserDb extends UserDbState {
  final String error;
  const ErrorUserDb({required this.error});
}
