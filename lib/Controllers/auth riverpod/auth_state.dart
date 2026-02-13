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
