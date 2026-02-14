import 'package:dio/dio.dart';
import 'package:pix_hunt_project/Models/pexer.dart';
import 'package:pix_hunt_project/core/errors/exceptions/dio_exceptions.dart';
import 'package:pix_hunt_project/core/errors/failures/failures.dart';
import 'package:pix_hunt_project/services/api_service.dart';

class ApiRepository {
  final ApiService apiService;
  ApiRepository({required this.apiService});

  Future<Pexer> fetchApi({String? search, int? pageNumber}) async {
    try {
      return await apiService.fetchImages(search, pageNumber);
    } on DioException catch (e) {
      var message = DioErrorHandler.handle(e);
      throw ApiFailure(message: message);
    }
  }
}
