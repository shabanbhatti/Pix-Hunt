import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/Models/dowloads_items_model.dart';
import 'package:pix_hunt_project/Models/fav_items.dart';
import 'package:pix_hunt_project/Models/search_history.dart';
import 'package:pix_hunt_project/Utils/toast.dart';
import 'package:pix_hunt_project/services/auth_service.dart';
import 'package:pix_hunt_project/services/cloud_DB_service.dart';
import 'package:pix_hunt_project/services/shared_preference_service.dart';
import 'package:pix_hunt_project/services/storage_service.dart';

class CloudDbRepository {
  final AuthService authService;
  final CloudDbService cloudDbService;
  final StorageService storageService;

  CloudDbRepository({
    required this.authService,
    required this.cloudDbService,
    required this.storageService,
  });

  Future<Auth> getUserData() async {
    try {
      String uid = authService.firebaseAuth.currentUser!.uid;
      return await cloudDbService.getUserData(uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> addFavItems(FavItemModalClass favItem) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.addFavouriteItems(favItem, uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> deleteFav(FavItemModalClass favItem) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.deleteFavourites(favItem, uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> addDownloadedPhotos(DownloadsItem downloadItems) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.addDownloadedPhotos(downloadItems, uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> deleteDownloadHistory(DownloadsItem downloadItems) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.deleteDownloadedHistory(downloadItems, uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> addSearchHistory(SearchHistory searchHistory) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.addSearchHistory(searchHistory, uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> removerSearchHistory(SearchHistory searchHistory) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.removeSearchHistory(searchHistory, uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> updateName(String name) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.updateName(name, uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> updateEmail(String email) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.updateEmail(email, uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Stream<List<FavItemModalClass>> favItemsStreams() {
    try {
      String uid = authService.firebaseAuth.currentUser!.uid;
      return cloudDbService.favItemsStreams(uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Stream<List<DownloadsItem>> downloadHistoryStream() {
    try {
      String uid = authService.firebaseAuth.currentUser!.uid;
      return cloudDbService.downloadHistoryStream(uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> userImage(File file) async {
    try {
      String uid = authService.firebaseAuth.currentUser!.uid;
      var storage = await storageService.putFile(file, '/user_img', 'img/$uid');
      await cloudDbService.userImage(uid, storage.url, storage.path);
      log(storage.url);
      log(storage.path);
      if (storage.url != '' || storage.url.isEmpty) {
        log('Called');
        SpService.setString(SpService.userImgKEY, storage.url);
      }
    } on FirebaseException catch (e) {
      log(e.code);
      ToastUtils.showToast(e.toString(), color: Colors.red);
      throw Exception(e.code);
    }
  }

  Future<void> deleteUserImage({bool? isLogout}) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await storageService.deleteFile('/user_img', 'img/$uid');
      await SpService.remove(SpService.userImgKEY);
      await cloudDbService.deleteUserImage(uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<String> getUserImage() async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      return cloudDbService.getUserImage(uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Stream<List<SearchHistory>> searchHistoryStream() {
    try {
      String uid = authService.firebaseAuth.currentUser!.uid;
      return cloudDbService.searchHitoryStream(uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> syncEmailAfterVerification() async {
    await authService.getCurrentUser();

    try {
      String uid = authService.firebaseAuth.currentUser!.uid;
      String email = authService.firebaseAuth.currentUser!.email ?? '';
      log('Loading......');
      await cloudDbService.syncEmailAfterVerification(email, uid);
      log('LOADED SUCCESS');
    } on FirebaseAuthException catch (e) {
      await SpService.setBool('logged', false);
      log(e.code);
      log(e.toString());
      throw Exception(e.code);
    }
  }
}
