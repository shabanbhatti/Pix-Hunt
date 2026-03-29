import 'package:cloud_functions/cloud_functions.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/core/errors/exceptions/firebase_exceptions_handler.dart';
import 'package:pix_hunt_project/core/errors/failures/failures.dart';
import 'package:pix_hunt_project/services/api_service.dart';
import 'package:pix_hunt_project/services/auth_service.dart';
import 'package:pix_hunt_project/services/local_database_service.dart';
import 'package:sqflite/sqlite_api.dart';

class ApiRepository {
  final ApiService apiService;
  final LocalDatabaseService localDatabaseService;
  final AuthService authService;
  ApiRepository({
    required this.apiService,
    required this.localDatabaseService,
    required this.authService,
  });

  Future<Pexer> fetchData({String? search, int? pageNumber}) async {
    try {
      var hasPexer = await localDatabaseService.hasPexer(
        search ?? '',
        pageNumber ?? 0,
      );
      if (hasPexer) {
        var pexer = await localDatabaseService.getPhotosByTitle(
          search ?? '',
          pageNumber ?? 0,
        );

        var photos = await localDatabaseService.getPhotos(
          pexer.title ?? '',
          pexer.page ?? 0,
        );

        return Pexer(page: pexer.page, title: pexer.title, photosList: photos);
      } else {
        String? uid = authService.firebaseAuth.currentUser?.uid;
        if (uid == null) {
          throw AuthFailure(message: 'Session expired. Please sign in again.');
        }
        var data = await apiService.fetchImages(search, pageNumber);
        await localDatabaseService.insertPhotosTitle(
          Pexer(page: pageNumber, title: search),
        );

        for (Photos index in data.photosList ?? []) {
          await localDatabaseService.insertPhotos(index);
        }

        var pexer = await localDatabaseService.getPhotosByTitle(
          search ?? '',
          pageNumber ?? 0,
        );

        var photos = await localDatabaseService.getPhotos(
          pexer.title ?? '',
          pexer.page ?? 0,
        );

        return Pexer(page: pexer.page, title: pexer.title, photosList: photos);
      }
    } on FirebaseFunctionsException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseFunctionExceptions(e);
      throw ApiFailure(message: message);
    } on DatabaseException catch (e) {
      throw DatabaseFailure(message: e.toString());
    }
  }

  Future<Pexer> fetchFromApi({String? search, int? pageNumber}) async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw AuthFailure(message: 'Session expired. Please sign in again.');
      }
      var data = await apiService.fetchImages(search, pageNumber);
      await localDatabaseService.insertPhotosTitle(
        Pexer(page: pageNumber, title: search),
      );

      for (Photos index in data.photosList ?? []) {
        await localDatabaseService.insertPhotos(index);
      }

      var pexer = await localDatabaseService.getPhotosByTitle(
        search ?? '',
        pageNumber ?? 0,
      );

      var photos = await localDatabaseService.getPhotos(
        pexer.title ?? '',
        pexer.page ?? 0,
      );

      return Pexer(page: pexer.page, title: pexer.title, photosList: photos);
    } on FirebaseFunctionsException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseFunctionExceptions(e);
      throw ApiFailure(message: message);
    } on DatabaseException catch (e) {
      throw DatabaseFailure(message: e.toString());
    }
  }

  Future<bool> updatePhoto(Photos photos) async {
    try {
      return await localDatabaseService.updatePhotos(photos);
    } on DatabaseException catch (e) {
      throw DatabaseFailure(message: e.toString());
    }
  }
}
