import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20controller/auth_state.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/core/errors/failures/failures.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/repository/auth_repository.dart';

final authProvider =
    StateNotifierProvider.family<AuthStateNotifier, AuthState, String>((
      ref,
      key,
    ) {
      return AuthStateNotifier(authRepository: getIt<AuthRepository>());
    });

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthRepository authRepository;

  AuthStateNotifier({required this.authRepository}) : super(Initial());

  // ---------CREATYE ACCOUNT

  Future<bool> isUserNull() async {
    try {
      state = AuthLoading();
      var user = await authRepository.isUserNull();
      state = AuthLoadedSuccessfuly();
      return user;
    } on Failures catch (e) {
      state = AuthError(error: e.message);
      return false;
    }
  }

  Future<bool> createAccount({
    required Auth auth,
    required String password,
  }) async {
    try {
      state = AuthLoading();

      var newUser = await authRepository.createAccount(auth, password);

      state = AuthLoadedSuccessfuly();
      return newUser;
    } on Failures catch (e) {
      state = AuthError(error: e.message);
      return false;
    }
  }

  // ---------LOGIN ACCOUNT

  Future<bool?> loginAccount({
    required String email,
    required String password,
  }) async {
    try {
      state = AuthLoading();

      var login = await authRepository.loginAccount(
        email: email,
        password: password,
      );

      state = AuthLoadedSuccessfuly();
      return login;
    } on Failures catch (e) {
      state = AuthError(error: e.message);
      return null;
    }
  }

  Future<void> forgotPassword(String email) async {
    state = AuthLoading();

    try {
      await authRepository.forgotPassword(email: email);
      state = AuthLoadedSuccessfuly();
    } on Failures catch (e) {
      state = AuthError(error: e.message);
    }
  }

  // ---------LIGIN WITH GOOGLE ACCOUNT

  Future<bool?> signInWithGOOGLE() async {
    state = AuthLoading();
    try {
      var isLogin = await authRepository.googleSignIn();

      state = AuthLoadedSuccessfuly();
      return isLogin;
    } on Failures catch (e) {
      state = AuthError(error: e.message);
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.signOut();
      state = AuthLoadedSuccessfuly();
    } on Failures catch (e) {
      state = AuthError(error: e.message);
    }
  }

  Future<void> updateEmail(String email, String password) async {
    try {
      state = AuthLoading();
      await authRepository.updateEmail(email: email, password: password);
      state = AuthLoadedSuccessfuly();
    } on Failures catch (e) {
      state = AuthError(error: e.message);
    }
  }

  Future<void> updateName(String name) async {
    try {
      state = AuthLoading();
      await authRepository.updateName(name: name);
      state = AuthLoadedSuccessfuly();
    } on Failures catch (e) {
      state = AuthError(error: e.message);
    }
  }
}
