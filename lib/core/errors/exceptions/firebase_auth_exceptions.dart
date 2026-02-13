import 'package:firebase_auth/firebase_auth.dart';

String handleFirebaseAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'Please enter a valid email address.';

    case 'user-disabled':
      return 'Your account has been disabled. Contact support.';

    case 'user-not-found':
      return 'No account found with this email.';

    case 'wrong-password':
      return 'Incorrect password. Please try again.';

    case 'invalid-credential':
      return 'Email or password is incorrect.';

    case 'account-exists-with-different-credential':
      return 'An account already exists with a different login method.';

    case 'credential-already-in-use':
      return 'This account is already being used.';

    case 'email-already-in-use':
      return 'This email is already registered. Try logging in.';

    case 'operation-not-allowed':
      return 'This login method is currently not available.';

    case 'weak-password':
      return 'Password is too weak. Use at least 6 characters.';

    case 'expired-action-code':
      return 'This link has expired. Please request a new one.';

    case 'invalid-action-code':
      return 'This link is invalid.';

    case 'missing-email':
      return 'Please enter your email address.';

    case 'network-request-failed':
      return 'No internet connection. Please check your network.';

    case 'too-many-requests':
      return 'Too many attempts. Please try again later.';

    case 'internal-error':
      return 'Something went wrong. Please try again.';

    case 'invalid-phone-number':
      return 'Please enter a valid phone number.';

    case 'missing-phone-number':
      return 'Phone number is required.';

    case 'quota-exceeded':
      return 'Too many OTP requests. Try again later.';

    case 'invalid-verification-code':
      return 'Incorrect OTP. Please try again.';

    case 'invalid-verification-id':
      return 'Verification failed. Try again.';

    case 'provider-already-linked':
      return 'This login method is already connected.';

    case 'requires-recent-login':
      return 'Please login again to continue.';

    default:
      return 'Login failed. Please try again.';
  }
}
