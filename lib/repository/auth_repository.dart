import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/services/auth_service.dart';
import 'package:pix_hunt_project/services/cloud_DB_service.dart';
import 'package:pix_hunt_project/services/shared_preference_service.dart';

class AuthRepository {
  final AuthService authService;
  final CloudDbService cloudDbService;

  AuthRepository({required this.authService, required this.cloudDbService});

  Future<bool> createAccount(Auth auth, String password) async {
    try {
      var create = await authService.createAccount(
        auth: auth,
        password: password,
      );
      await cloudDbService.addUser(auth, create.user!.uid.toString());
      return true;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<bool> isUserNull() async {
    try {
      return await authService.isUserNull();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<bool?> loginAccount({
    required String email,
    required String password,
  }) async {
    try {
      var isLogin = await authService.loginAccount(
        email: email,
        password: password,
      );
      var uid = await authService.getCurrentUserUid();
      var user = await cloudDbService.getUserData(uid);
      log(user.name ?? '');
      SpService.setString('username', user.name ?? '');
      return isLogin;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    try {
      await authService.logout();
      await SpService.setBool(SpService.loggedKEY, false);
      await SpService.remove(SpService.userImgKEY);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await authService.forgotPassword(email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<bool?> googleSignIn() async {
    try {
      var create = await authService.signInWithGOOGLE();
      if (create != null) {
        await cloudDbService.addUser(create, create.uid.toString());
        SpService.setString('username', create.name ?? '');
        return true;
      } else {
        return null;
      }
    } on GoogleSignInException catch (e) {
      return throw Exception(e.code);
    }
  }

  Future<void> updateEmail({
    required String email,
    required String password,
  }) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await authService.updateEmail(email, password);
      await cloudDbService.updateEmail(email, uid);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> updateName({required String name}) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await authService.updateUserName(name);
      await cloudDbService.updateName(name, uid);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<User?> getCurrentuserWithReload() async {
    try {
      return await authService.getCurrentUser();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
