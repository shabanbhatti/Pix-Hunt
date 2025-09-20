



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/Models/dowloads_items_model.dart';
import 'package:pix_hunt_project/Models/fav_items.dart';
import 'package:pix_hunt_project/Models/search_history.dart';
import 'package:pix_hunt_project/providers/app_provider_objects.dart';
import 'package:pix_hunt_project/repository/cloud_db_repository.dart';


final userDbProvider = StateNotifierProvider.autoDispose<UserDbStateNotifier, UserDbState>((
  ref,
) {
  return UserDbStateNotifier(cloudDbRepository: ref.read(cloudDbRepositoryProviderObject));
});

class UserDbStateNotifier extends StateNotifier<UserDbState> {
  CloudDbRepository cloudDbRepository;
  UserDbStateNotifier({required this.cloudDbRepository}) : super(InitialUserDb());



  Future<void> fetchUserDbData() async {
  
    state = LoadingUserDb();
    try {
     var auth=await cloudDbRepository.getUserData();

      state = LoadedSuccessfulyUserDb(auth: auth);
    } catch (e) {
      state = ErrorUserDb(error: e.toString());
    }
  }

  Future<void> addFavouriteItems(FavItemModalClass favItemModalClass,) async {
      
    try {
     await cloudDbRepository.addFavItems(favItemModalClass);
    }catch (e) {
     state = ErrorUserDb(error: e.toString());
    }
  }

  Future<void> deleteFavourites(FavItemModalClass favItemModalClass) async {
    try {
    await cloudDbRepository.deleteFav(favItemModalClass);
    } catch (e) {
      state = ErrorUserDb(error: e.toString());
    }
  }

  Future<void> addDownloadedPhotos(DownloadsItem downloadedItems) async {
 
    try {
        
   await cloudDbRepository.addDownloadedPhotos(downloadedItems);
    }catch (e) {
      state = ErrorUserDb(error: e.toString());
    }
  }

  Future<void> deleteDownloadedHistory(DownloadsItem downloadedItems) async {
    try {
      await cloudDbRepository.deleteDownloadHistory(downloadedItems);
    }  catch (e) {
      state = ErrorUserDb(error: e.toString());
    }
  }

  Future<void> addSearchHistory(SearchHistory searchHistory) async {
    
    try {
    await cloudDbRepository.addSearchHistory(searchHistory);
    }  catch (e) {
      state = ErrorUserDb(error: e.toString());
    }
  }

  Future<void> removeSearchHistory(SearchHistory searchHistory) async {
      try{
        await cloudDbRepository.removerSearchHistory(searchHistory);
    } catch (e) {
      state = ErrorUserDb(error: e.toString());
    }
  }




}

sealed class UserDbState {
  const UserDbState();
}

class InitialUserDb extends UserDbState {
  const InitialUserDb();
}

class LoadingUserDb extends UserDbState {
  const LoadingUserDb();
}

class LoadedSuccessfulyUserDb extends UserDbState {
  final Auth auth;
  
  const LoadedSuccessfulyUserDb({required this.auth,});
}

class ErrorUserDb extends UserDbState {
  final String error;
  const ErrorUserDb({required this.error});
}
