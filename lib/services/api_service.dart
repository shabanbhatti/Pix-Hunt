import 'package:dio/dio.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/core/errors/failures/failures.dart';

class ApiService {
  final Dio dio;
  const ApiService({required this.dio});

  Future<Pexer> fetchImages(String? search, int? pageNumber) async {
    var responce = await dio.get(
      '/search',
      queryParameters: {'query': search, 'per_page': 50, 'page': pageNumber},
    );
    var pexer = responce.data;
    if (responce.statusCode == 200 || responce.statusCode == 201) {
      List<dynamic> photos = pexer['photos'];
      Map<String, dynamic> json = {
        'pages': pageNumber,
        'title': search,
        'photos':
            photos
                .map(
                  (e) => {
                    'describtion': e['alt'] ?? '',
                    'largeImg': e['src']['large'],
                    'mediumImg': e['src']['medium'],
                    'originalImg': e['src']['original'],
                    'photographer': e['photographer'] ?? '',
                    'photographerUrl': e['photographer_url'] ?? '',
                    'smallImg': e['src']['small'],
                    'url': e['url'] ?? '',
                    'id': e['id'] ?? 0,
                    'page': pageNumber,
                    'title': search,
                    'isBookmarked': false,
                  },
                )
                .toList(),
      };

      return Pexer.fromJson(json);
    } else {
      throw RandomFailure(message: 'Something went wrong');
    }
  }
}
