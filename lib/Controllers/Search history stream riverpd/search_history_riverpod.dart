
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Models/search_history.dart';
import 'package:pix_hunt_project/providers/app_provider_objects.dart';

final searchHistoryStreamProvider =
    StreamProvider.autoDispose<List<SearchHistory>>((ref) {
      var cloudRep = ref.read(cloudDbRepositoryProviderObject);

      return cloudRep.searchHistoryStream();
    });
