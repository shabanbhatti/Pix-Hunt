import 'dart:convert';

import 'package:http/http.dart';
import 'package:pix_hunt_project/Models/pexer.dart';
import 'package:pix_hunt_project/Utils/constants_env.dart';

class ApiService {
  String api(String search, String pageNumber) {
    return 'https://api.pexels.com/v1/search?query=$search&per_page=500&page=$pageNumber';
  }

  Future<Pexer> fetchImages({String? search, int? pageNumber}) async {
    var responce = await get(
      Uri.parse(api(search!, pageNumber.toString())),
      headers: {'Authorization': EnvUtils.apiKey ?? ''},
    );

    print(responce.body);
    Map<String, dynamic> decodeRes = jsonDecode(responce.body);

    if (responce.statusCode == 200 || responce.statusCode == 201) {
      return Pexer.fromJson(decodeRes);
    } else {
      return throw Exception('Erro 404 found');
    }
  }
}
