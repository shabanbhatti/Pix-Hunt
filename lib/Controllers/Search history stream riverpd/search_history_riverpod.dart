import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Models/search_history.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/repository/cloud_db_repository.dart';

final searchHistoryStreamProvider =
    StreamProvider.autoDispose<List<SearchHistory>>((ref) {
      var cloudRep = getIt<CloudDbRepository>();

      return cloudRep.searchHistoryStream();
    });
