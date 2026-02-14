import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pix_hunt_project/Models/pexer.dart';
import 'package:pix_hunt_project/core/errors/failures/failures.dart';

class ApiService {
  final Dio dio;
  const ApiService({required this.dio});

  Future<Pexer> fetchImages(String? search, int? pageNumber) async {
    log('Called');
    var responce = await dio.get(
      'search?query=$search&per_page=500&page=$pageNumber',
    );
    var pexer = responce.data;
    if (responce.statusCode == 200 || responce.statusCode == 201) {
      return Pexer.fromJson(pexer);
    } else {
      throw RandomFailure(message: 'Something went wrong');
    }
  }
}
