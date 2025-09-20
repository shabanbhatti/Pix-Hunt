import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/repository/api_repository.dart';
import 'package:pix_hunt_project/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pix_hunt_project/repository/auth_repository.dart';
import 'package:pix_hunt_project/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pix_hunt_project/repository/cloud_db_repository.dart';
import 'package:pix_hunt_project/services/cloud_DB_service.dart';
import 'package:pix_hunt_project/services/storage_service.dart';


final apiServiceObjectProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final apiRepositoryObjectProvider = Provider<ApiRepository>((ref) {
  return ApiRepository(apiService: ref.read(apiServiceObjectProvider));
});



final authServiceProviderObject = Provider<AuthService>((ref) {
  return AuthService(firebaseAuth: FirebaseAuth.instance, googleSignIn: GoogleSignIn.instance);
});


final authRepositoryProviderObject = Provider<AuthRepository>((ref) {
  return AuthRepository(authService: ref.read(authServiceProviderObject), cloudDbService: ref.read(cloudDbServiceProviderObject));
});




final cloudDbServiceProviderObject = Provider<CloudDbService>((ref) {
  return CloudDbService(firestore: FirebaseFirestore.instance);
});



final storageServiceProviderObject = Provider<StorageService>((ref) {
  return StorageService(firebaseStorage: FirebaseStorage.instance);
});




final cloudDbRepositoryProviderObject = Provider<CloudDbRepository>((ref) {
  return CloudDbRepository(
    authService: ref.read(authServiceProviderObject),
    cloudDbService: ref.read(cloudDbServiceProviderObject),
    storageService: ref.read(storageServiceProviderObject)
  );
});

