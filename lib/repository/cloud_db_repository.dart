import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/Models/downloads_image_model.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Models/search_history.dart';
import 'package:pix_hunt_project/core/constants/constants_sharedPref_keys.dart';
import 'package:pix_hunt_project/core/errors/exceptions/firebase_exceptions_handler.dart';
import 'package:pix_hunt_project/core/errors/exceptions/google_signin_exceptions.dart';
import 'package:pix_hunt_project/core/errors/failures/failures.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/core/services/shared_preference_service.dart';
import 'package:pix_hunt_project/services/auth_service.dart';
import 'package:pix_hunt_project/services/cloud_DB_service.dart';
import 'package:pix_hunt_project/services/local_database_service.dart';
import 'package:pix_hunt_project/services/storage_service.dart';
import 'package:sqflite/sqflite.dart';

class CloudDbRepository {
  final AuthService authService;
  final CloudDbService cloudDbService;
  final StorageService storageService;
  final LocalDatabaseService localDatabaseService;

  CloudDbRepository({
    required this.authService,
    required this.cloudDbService,
    required this.storageService,
    required this.localDatabaseService,
  });

  Future<Auth> getUserData() async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      return await cloudDbService.getUserData(uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> onLogin() async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      await authService.firebaseAuth.currentUser?.reload();

      String currentUserEmail =
          authService.firebaseAuth.currentUser?.email ?? '';
      String? email = await cloudDbService.getEmailFromDb(uid);
      log('Current email: ${currentUserEmail}');
      log(' email: ${email}');

      if (email != currentUserEmail) {
        await cloudDbService.onLogin(currentUserEmail, uid);
        await cloudDbService.getUserData(uid);
      }
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> addToBookmark(Photos favItem) async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      await cloudDbService.addToBookmark(favItem, uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> deleteBookmark(Photos favItem) async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      await cloudDbService.deleteFavourites(favItem, uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> addDownloadedPhotos(
    DownloadsImageModel downloadImagesModel,
  ) async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      await cloudDbService.addDownloadedPhotos(downloadImagesModel, uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> deleteDownloadHistory(
    DownloadsImageModel downloadImagesModel,
  ) async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      await cloudDbService.deleteDownloadedHistory(downloadImagesModel, uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> deleteAllDownloadHistory() async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      await cloudDbService.deleteAllDownloadedHistory(uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> addSearchHistory(SearchHistory searchHistory) async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      await cloudDbService.addSearchHistory(searchHistory, uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> removerSearchHistory(SearchHistory searchHistory) async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      await cloudDbService.removeSearchHistory(searchHistory, uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> updateName(String name) async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      await cloudDbService.updateName(name, uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      await cloudDbService.updateEmail(email, uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Stream<List<Photos>> getAllBookmarks() {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      return cloudDbService.bookmarks(uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Stream<List<DownloadsImageModel>> downloadHistoryStream() {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }

      return cloudDbService.downloadHistoryStream(uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> userImage(File file) async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      var storage = await storageService.putFile(file, '/user_img', 'img/$uid');
      await cloudDbService.userImage(uid, storage.url, storage.path);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> deleteUserImage({bool? isLogout}) async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      await storageService.deleteFile('/user_img', 'img/$uid');
      await cloudDbService.deleteUserImage(uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<String> getUserImage() async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      return cloudDbService.getUserImage(uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Stream<List<SearchHistory>> searchHistoryStream() {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      return cloudDbService.searchHitoryStream(uid);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<void> deleteAccount(String password, bool isGoogleSignIn) async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      if (isGoogleSignIn) {
        await authService.reAuthenticateWithGoogle();
      } else {
        await authService.reAuthenticateUser(password);
      }

      var path = await cloudDbService.getUserImageStoragePath(uid);
      if (path != null) {
        await storageService.deleteFile('/user_img', 'img/$uid');
      }

      await cloudDbService.deleteAccount(uid);

      await localDatabaseService.deleteAllData();

      await authService.deleteAccount(password);

      await authService.logout();
      var spService = getIt<SharedPreferencesService>();
      await spService.setBool(ConstantsSharedprefKeys.googleSignin, false);
      await spService.setBool(ConstantsSharedprefKeys.loggedKEY, false);
      await spService.remove(ConstantsSharedprefKeys.userImgKEY);
    } on GoogleSignInException catch (e) {
      var message = GoogleSignInExceptionsHandler.googleSignInError(e);
      throw AuthFailure(message: message);
    } on FirebaseAuthException catch (e) {
      log(e.code);
      if (e.code == 'invalid-credential' || e.credential == 'wrong-password') {
        throw AuthFailure(message: 'Incorrect Password');
      } else if (e.code == 'user-mismatch') {
        throw AuthFailure(message: 'Incorrect Account');
      } else {
        var message = FirebaseExceptionsHandler.authException(e);
        throw AuthFailure(message: message);
      }
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    } on DatabaseException catch (e) {
      throw DatabaseFailure(message: e.toString());
    }
  }
}
