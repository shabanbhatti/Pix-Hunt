// 1. Firebase References
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Models/fav_items.dart';
import 'package:pix_hunt_project/providers/app_provider_objects.dart';

final favStreamProvider = StreamProvider.autoDispose<List<FavItemModalClass>>((
  ref,
) {
  var cloudRep = ref.read(cloudDbRepositoryProviderObject);
  
  return cloudRep.favItemsStreams();
});

final searchListProvider =
    StateNotifierProvider<SearchListStateNotifier, List<FavItemModalClass>>((
      ref,
    ) {
      return SearchListStateNotifier();
    });

class SearchListStateNotifier extends StateNotifier<List<FavItemModalClass>> {
  SearchListStateNotifier() : super([]);

  List<FavItemModalClass> originalItems = [];

  void updateOriginalList(List<FavItemModalClass> newItems) {
    originalItems = newItems;
    state = newItems;
  }

  void search(String query) {
    if (query.isEmpty) {
      state = [...originalItems];
    } else {
      state =
          originalItems
              .where(
                (item) =>
                    item.title.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
  }
}
