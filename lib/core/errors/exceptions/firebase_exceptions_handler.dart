import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseExceptionsHandler {
  static String authException(FirebaseAuthException e) {
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

  static String firebaseExceptions(FirebaseException e) {
    log(e.code);
    switch (e.code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';

      case 'unauthenticated':
        return 'Please sign in to continue.';

      case 'unauthorized':
        return 'You are not allowed to access this content.';

      case 'not-found':
      case 'object-not-found':
        return 'The requested data was not found.';

      case 'already-exists':
        return 'This item already exists.';

      case 'resource-exhausted':
      case 'quota-exceeded':
        return 'Service limit reached. Please try again later.';

      case 'unavailable':
        return 'Service is temporarily unavailable. Please try again later.';

      case 'deadline-exceeded':
        return 'The request took too long. Please try again.';

      case 'cancelled':
      case 'canceled':
        return 'Operation was cancelled.';
      case 'user-token-expired':
        return 'Session expired. Please sign in again.';
      case 'invalid-argument':
      case 'invalid-url':
      case 'invalid-event-name':
        return 'Invalid data provided.';

      case 'bucket-not-found':
        return 'Storage service is not available right now.';

      case 'project-not-found':
        return 'Project configuration error. Please try again later.';

      case 'no-default-bucket':
        return 'Storage is not configured properly. Please try again later.';

      case 'invalid-checksum':
        return 'File seems corrupted. Please upload again.';

      case 'cannot-slice-blob':
        return 'Unable to process the file. Please try another one.';

      case 'server-file-wrong-size':
        return 'Uploaded file size mismatch. Please try again.';

      case 'retry-limit-exceeded':
        return 'Too many attempts. Please try again later.';

      case 'failed-precondition':
        return 'Operation cannot be completed right now. Please try again.';

      case 'aborted':
        return 'Operation could not be completed. Please retry.';

      case 'out-of-range':
        return 'Operation is out of allowed range.';

      case 'unimplemented':
        return 'This feature is not available yet.';

      case 'internal':
        return 'Something went wrong on our side. Please try again later.';

      case 'data-loss':
        return 'Unexpected error occurred. Please try again.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
