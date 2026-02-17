import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/core/errors/exceptions/dio_exceptions.dart';
import 'package:pix_hunt_project/core/errors/failures/failures.dart';
import 'package:pix_hunt_project/services/api_service.dart';
import 'package:pix_hunt_project/services/local_database_service.dart';
import 'package:sqflite/sqlite_api.dart';

class ApiRepository {
  final ApiService apiService;
  final LocalDatabaseService localDatabaseService;
  ApiRepository({required this.apiService, required this.localDatabaseService});

  Future<Pexer> fetchApi({String? search, int? pageNumber}) async {
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
        print(pexer.page);

        var photos = await localDatabaseService.getPhotos(
          pexer.title ?? '',
          pexer.page ?? 0,
        );

        return Pexer(page: pexer.page, title: pexer.title, photosList: photos);
      } else {
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
        print(pexer.page);

        var photos = await localDatabaseService.getPhotos(
          pexer.title ?? '',
          pexer.page ?? 0,
        );

        return Pexer(page: pexer.page, title: pexer.title, photosList: photos);
      }
    } on DioException catch (e) {
      var message = DioErrorHandler.handle(e);
      throw ApiFailure(message: message);
    } on DatabaseException catch (e) {
      log(e.toString());
      throw DatabaseFailure(message: e.toString());
    }
  }

  Future<bool> updatePhoto(Photos photos) async {
    try {
      log(photos.isBookmarked.toString());
      return await localDatabaseService.updatePhotos(photos);
    } on DatabaseException catch (e) {
      throw DatabaseFailure(message: e.toString());
    }
  }
}
