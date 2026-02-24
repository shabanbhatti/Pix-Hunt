import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pix_hunt_project/core/Utils/internet_checker_util.dart';
import 'package:pix_hunt_project/core/database/app_database.dart';
import 'package:pix_hunt_project/core/dio%20client/dio_client.dart';
import 'package:pix_hunt_project/repository/api_repository.dart';
import 'package:pix_hunt_project/repository/auth_repository.dart';
import 'package:pix_hunt_project/repository/cloud_db_repository.dart';
import 'package:pix_hunt_project/services/api_service.dart';
import 'package:pix_hunt_project/services/auth_service.dart';
import 'package:pix_hunt_project/services/cloud_DB_service.dart';
import 'package:pix_hunt_project/services/local_database_service.dart';
import 'package:pix_hunt_project/core/services/shared_preference_service.dart';
import 'package:pix_hunt_project/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

Future<void> initGetIt() async {
  getIt.registerLazySingleton(
    () => InternetCheckerUtil(
      internetChecker: InternetConnectionChecker.instance,
    ),
  );
  getIt.registerLazySingleton<CloudDbService>(
    () => CloudDbService(firestore: FirebaseFirestore.instance),
  );
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(
      firebaseAuth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn.instance,
    ),
  );
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(dio: getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton(
    () => LocalDatabaseService(appDatabase: AppDatabase()),
  );
  getIt.registerLazySingleton<ApiRepository>(
    () => ApiRepository(
      apiService: getIt<ApiService>(),
      localDatabaseService: getIt<LocalDatabaseService>(),
    ),
  );
  getIt.registerLazySingleton<StorageService>(
    () => StorageService(firebaseStorage: FirebaseStorage.instance),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      authService: getIt<AuthService>(),
      cloudDbService: getIt<CloudDbService>(),
    ),
  );
  getIt.registerLazySingleton<CloudDbRepository>(
    () => CloudDbRepository(
      authService: getIt<AuthService>(),
      cloudDbService: getIt<CloudDbService>(),
      storageService: getIt<StorageService>(),
    ),
  );

  SharedPreferences sp = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(
    () => SharedPreferencesService(sharedPreferences: sp),
  );
}
