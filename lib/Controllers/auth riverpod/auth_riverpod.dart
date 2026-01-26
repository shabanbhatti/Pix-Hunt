import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/providers/app_provider_objects.dart';
import 'package:pix_hunt_project/repository/auth_repository.dart';

final authProvider =
    StateNotifierProvider.family<AuthStateNotifier, AuthState, String>((
      ref,
      key,
    ) {
      return AuthStateNotifier(
        authRepository: ref.read(authRepositoryProviderObject),
      );
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
    } catch (e) {
      state = AuthError(error: e.toString());
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
    } catch (e) {
      state = AuthError(error: e.toString());
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
    } catch (e) {
      state = AuthError(error: e.toString());
      return null;
    }
  }

  Future<void> forgotPassword(String email) async {
    state = AuthLoading();

    try {
      await authRepository.forgotPassword(email: email);
      state = AuthLoadedSuccessfuly();
    } catch (e) {
      state = AuthError(error: e.toString());
    }
  }

  // ---------LIGIN WITH GOOGLE ACCOUNT

  Future<bool?> signInWithGOOGLE() async {
    state = AuthLoading();
    try {
      var isLogin = await authRepository.googleSignIn();

      state = AuthLoadedSuccessfuly();
      return isLogin;
    } catch (e) {
      state = AuthError(error: e.toString());
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.signOut();
      state = AuthLoadedSuccessfuly();
    } catch (e) {
      state = AuthError(error: e.toString());
    }
  }

  Future<void> updateEmail(String email, String password) async {
    try {
      state = AuthLoading();
      await authRepository.updateEmail(email: email, password: password);
      state = AuthLoadedSuccessfuly();
    } catch (e) {
      state = AuthError(error: e.toString());
    }
  }

  Future<void> updateName(String name) async {
    try {
      state = AuthLoading();
      await authRepository.updateName(name: name);
      state = AuthLoadedSuccessfuly();
    } catch (e) {
      state = AuthError(error: e.toString());
    }
  }
}

sealed class AuthState {
  const AuthState();
}

class Initial extends AuthState {
  const Initial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthLoadedSuccessfuly extends AuthState {
  const AuthLoadedSuccessfuly();
}

class AuthError extends AuthState {
  final String error;
  const AuthError({required this.error});
}
