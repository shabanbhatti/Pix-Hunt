import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/core/constants/constants_sharedPref_keys.dart';
import 'package:pix_hunt_project/core/errors/exceptions/firebase_exceptions_handler.dart';
import 'package:pix_hunt_project/core/errors/exceptions/google_signin_exceptions.dart';
import 'package:pix_hunt_project/core/errors/failures/failures.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/services/auth_service.dart';
import 'package:pix_hunt_project/services/cloud_DB_service.dart';
import 'package:pix_hunt_project/core/services/shared_preference_service.dart';

class AuthRepository {
  final AuthService authService;
  final CloudDbService cloudDbService;

  AuthRepository({required this.authService, required this.cloudDbService});
  Future<void> onLogin() async {
    try {
      String? uid = authService.firebaseAuth.currentUser?.uid;
      if (uid != null) {
        String currentUserEmail =
            authService.firebaseAuth.currentUser?.email ?? '';
        String? email = await cloudDbService.getEmailFromDb(uid);
        log('Current email: ${currentUserEmail}');
        log(' email: ${email}');
        print('Current email== email: ${email == currentUserEmail}');
        print('Current email!= email: ${email != currentUserEmail}');
        if (email != currentUserEmail) {
          await cloudDbService.onLogin(currentUserEmail, uid);
          await cloudDbService.getUserData(uid);
        }
      }
    } on FirebaseAuthException catch (e) {
      var message = FirebaseExceptionsHandler.authException(e);
      throw AuthFailure(message: message);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    }
  }

  Future<bool> createAccount(Auth auth, String password) async {
    try {
      var create = await authService.createAccount(
        auth: auth,
        password: password,
      );
      await cloudDbService.addUser(auth, create.user!.uid.toString());
      return true;
    } on FirebaseAuthException catch (e) {
      var message = FirebaseExceptionsHandler.authException(e);
      throw AuthFailure(message: message);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    } catch (e) {
      throw RandomFailure(message: 'Something went wrong, Please try again');
    }
  }

  Future<bool> isUserNull() async {
    try {
      return await authService.isUserNull();
    } on FirebaseAuthException catch (e) {
      var message = FirebaseExceptionsHandler.authException(e);
      throw AuthFailure(message: message);
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await authService.changePassword(oldPassword, newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.credential == 'wrong-password') {
        throw AuthFailure(message: 'Incorrect Password');
      } else {
        var message = FirebaseExceptionsHandler.authException(e);
        throw AuthFailure(message: message);
      }
    }
  }

  Future<bool?> loginAccount({
    required String email,
    required String password,
  }) async {
    try {
      var spService = getIt<SharedPreferencesService>();
      var isLogin = await authService.loginAccount(
        email: email,
        password: password,
      );
      var uid = await authService.getCurrentUserUid();
      var user = await cloudDbService.getUserData(uid);
      spService.setString(ConstantsSharedprefKeys.usernameKey, user.name ?? '');
      return isLogin;
    } on FirebaseAuthException catch (e) {
      var message = FirebaseExceptionsHandler.authException(e);
      throw AuthFailure(message: message);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    } catch (e) {
      throw RandomFailure(message: 'Something went wrong, Please try again');
    }
  }

  Future<void> signOut() async {
    try {
      var spService = getIt<SharedPreferencesService>();
      await authService.logout();
      await spService.setBool(ConstantsSharedprefKeys.loggedKEY, false);
      await spService.remove(ConstantsSharedprefKeys.userImgKEY);
    } on FirebaseAuthException catch (e) {
      var message = FirebaseExceptionsHandler.authException(e);
      throw AuthFailure(message: message);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await authService.forgotPassword(email);
    } on FirebaseAuthException catch (e) {
      var message = FirebaseExceptionsHandler.authException(e);
      throw AuthFailure(message: message);
    }
  }

  Future<bool?> googleSignIn() async {
    try {
      var spService = getIt<SharedPreferencesService>();
      var create = await authService.signInWithGOOGLE();
      if (create != null) {
        await cloudDbService.addUser(create, create.uid.toString());
        spService.setString(
          ConstantsSharedprefKeys.usernameKey,
          create.name ?? '',
        );
        return true;
      } else {
        return null;
      }
    } on GoogleSignInException catch (e) {
      var message = GoogleSignInExceptionsHandler.googleSignInError(e);
      throw AuthFailure(message: message);
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
      if (e.code == 'invalid-credential' || e.credential == 'wrong-password') {
        throw AuthFailure(message: 'Incorrect Password');
      } else {
        var message = FirebaseExceptionsHandler.authException(e);
        throw AuthFailure(message: message);
      }
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    } catch (e) {
      throw RandomFailure(message: 'Something went wrong, Please try again');
    }
  }

  Future<void> updateName({required String name}) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await authService.updateUserName(name);
      await cloudDbService.updateName(name, uid);
    } on FirebaseAuthException catch (e) {
      var message = FirebaseExceptionsHandler.authException(e);
      throw AuthFailure(message: message);
    } on FirebaseException catch (e) {
      var message = FirebaseExceptionsHandler.firebaseExceptions(e);
      throw FirebaseFailure(message: message);
    } catch (e) {
      throw RandomFailure(message: 'Something went wrong, Please try again');
    }
  }
}
