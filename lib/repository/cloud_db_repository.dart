import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/Models/downloads_image_model.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Models/search_history.dart';
import 'package:pix_hunt_project/services/auth_service.dart';
import 'package:pix_hunt_project/services/cloud_DB_service.dart';
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

  Future<void> addToBookmark(Photos favItem) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.addToBookmark(favItem, uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> deleteBookmark(Photos favItem) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.deleteFavourites(favItem, uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> addDownloadedPhotos(
    DownloadsImageModel downloadImagesModel,
  ) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.addDownloadedPhotos(downloadImagesModel, uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> deleteDownloadHistory(
    DownloadsImageModel downloadImagesModel,
  ) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.deleteDownloadedHistory(downloadImagesModel, uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> deleteAllDownloadHistory() async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await cloudDbService.deleteAllDownloadedHistory(uid);
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

  Stream<List<Photos>> getAllBookmarks() {
    try {
      String uid = authService.firebaseAuth.currentUser!.uid;
      return cloudDbService.bookmarks(uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Stream<List<DownloadsImageModel>> downloadHistoryStream() {
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
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> deleteUserImage({bool? isLogout}) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await storageService.deleteFile('/user_img', 'img/$uid');
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

      await cloudDbService.syncEmailAfterVerification(email, uid);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
