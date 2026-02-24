import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/repository/cloud_db_repository.dart';

final bookmarkStreamProvider = StreamProvider.autoDispose<List<Photos>>((ref) {
  var cloudRep = getIt<CloudDbRepository>();

  return cloudRep.getAllBookmarks();
});

final searchListProvider =
    StateNotifierProvider<SearchListStateNotifier, List<Photos>>((ref) {
      return SearchListStateNotifier();
    });

class SearchListStateNotifier extends StateNotifier<List<Photos>> {
  SearchListStateNotifier() : super([]);

  List<Photos> originalItems = [];

  void updateOriginalList(List<Photos> newItems) {
    originalItems = newItems;
    state = newItems;
  }

  void search(String query) {
    if (query.isEmpty) {
      state = [...originalItems];
    } else {
      state =
          originalItems.where((item) {
            String title = item.title ?? '';
            return title.toLowerCase().contains(query.toLowerCase());
          }).toList();
    }
  }
}
