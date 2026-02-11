import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/core/constants/constants_env.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthService({required this.firebaseAuth, required this.googleSignIn});

  Future<User?> getCurrentUser() async {
    await firebaseAuth.currentUser?.reload();
    return firebaseAuth.currentUser;
  }

  Future<bool> isUserNull() async {
    var user = await firebaseAuth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getCurrentUserUid() async {
    return firebaseAuth.currentUser!.uid;
  }

  Future<UserCredential> createAccount({
    required Auth auth,
    required String password,
  }) async {
    var newUser = await firebaseAuth.createUserWithEmailAndPassword(
      email: auth.email!,
      password: password,
    );
    await newUser.user?.sendEmailVerification();
    return newUser;
  }

  Future<void> updateUserName(String name) async {
    var user = firebaseAuth.currentUser;
    if (name != user?.displayName && name != '') {
      await user?.updateDisplayName(name);
    }
  }

  Future<void> updateEmail(String newEmail, String password) async {
    var user = firebaseAuth.currentUser;
    if (newEmail != user?.email) {
      final cred = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: password,
      );
      await firebaseAuth.currentUser?.reauthenticateWithCredential(cred);

      await user?.verifyBeforeUpdateEmail(newEmail);
    }
  }

  Future<bool?> loginAccount({
    required String email,
    required String password,
  }) async {
    var user = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (user.user != null) {
      var isEmailVerified = user.user?.emailVerified ?? false;
      if (isEmailVerified) {
        return true;
      } else {
        firebaseAuth.signOut();
        return false;
      }
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    await googleSignIn.disconnect();
  }

  Future<void> forgotPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<Auth?> signInWithGOOGLE() async {
    try {
      await googleSignIn.initialize(serverClientId: EnvUtils.serverClientId);

      GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.authenticate();

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential = await firebaseAuth.signInWithCredential(
        authCredential,
      );

      Auth auth = Auth(
        email: userCredential.user?.email,
        name: userCredential.user?.displayName,
        uid: userCredential.user?.uid,
        createdAtDate: DateTime.now().toString(),
      );
      return auth;
    } catch (e) {
      if (e.toString().contains('canceled')) {
        return null;
      }
      log(e.toString());
      throw Exception(e.toString());
    }
  }
}
