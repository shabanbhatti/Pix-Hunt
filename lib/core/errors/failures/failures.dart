abstract class Failures {
  final String message;
  const Failures({required this.message});
}

class AuthFailure extends Failures {
  const AuthFailure({required super.message});
}
