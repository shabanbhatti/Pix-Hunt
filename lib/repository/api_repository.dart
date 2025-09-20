import 'package:pix_hunt_project/Models/pexer.dart';
import 'package:pix_hunt_project/services/api_service.dart';


class ApiRepository {
  
  final ApiService apiService;
 ApiRepository({required this.apiService});


Future<Pexer> fetchApi({String? search, int? pageNumber}) async {
  
  try {
    return await apiService.fetchImages(search: search, pageNumber: pageNumber);

    
  }catch(e){
    throw Exception('$e');
  }
}




}