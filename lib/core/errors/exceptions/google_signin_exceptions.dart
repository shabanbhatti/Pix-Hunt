import 'package:google_sign_in/google_sign_in.dart';

abstract class GoogleSignInExceptionsHandler {
  static String googleSignInError(GoogleSignInException e) {
    switch (e.code) {
      case GoogleSignInExceptionCode.canceled:
        return 'Sign in was cancelled. Please try again if you want to continue.';

      case GoogleSignInExceptionCode.interrupted:
        return 'Sign in was interrupted. Please try again.';

      case GoogleSignInExceptionCode.clientConfigurationError:
        return 'Unable to sign in right now. Please try again later.';

      case GoogleSignInExceptionCode.unknownError:
        return 'Something went wrong during sign in. Please try again.';

      default:
        return 'Unable to sign in with Google at the moment. Please try again.';
    }
  }
}
