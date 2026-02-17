abstract class Failures {
  final String message;
  const Failures({required this.message});
}

class AuthFailure extends Failures {
  const AuthFailure({required super.message});
}

class ApiFailure extends Failures {
  ApiFailure({required super.message});
}

class DatabaseFailure extends Failures {
  DatabaseFailure({required super.message});
}

class RandomFailure extends Failures {
  RandomFailure({required super.message});
}
