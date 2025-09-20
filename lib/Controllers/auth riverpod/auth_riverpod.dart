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

  Future<void> createAccount({
    required Auth auth,
    required String password,
  }) async {
    try {
      state = AuthLoading();

      await authRepository.createAccount(auth, password);

      state = AuthLoadedSuccessfuly();
    } catch (e) {
      state = AuthError(error: e.toString());
    }
  }

  // ---------LOGIN ACCOUNT

  Future<void> loginAccount({
    required String email,
    required String password,
  }) async {
    try {
      state = AuthLoading();

      await authRepository.loginAccount(email: email, password: password);
      
      state = AuthLoadedSuccessfuly();
    } catch (e) {
      state = AuthError(error: e.toString());
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

  Future<void> signInWithGOOGLE() async {
    state = AuthLoading();
    try {
      await authRepository.googleSignIn();
      

      state = AuthLoadedSuccessfuly();
    } catch (e) {
      state = AuthError(error: e.toString());
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


Future<void> updateEmail( String email,String password,)async{
try {
  state= AuthLoading();
  await authRepository.updateEmail(email: email, password: password);
  state= AuthLoadedSuccessfuly();
} catch (e) {
  state = AuthError(error: e.toString());
}

}

Future<void> updateName( String name)async{
try {
  state= AuthLoading();
  await authRepository.updateName(name: name);
  state= AuthLoadedSuccessfuly();
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
