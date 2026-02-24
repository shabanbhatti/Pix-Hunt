import 'package:flutter/material.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

abstract class ValidationsTextfieldsUtils {
  static String? emailValidation(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)?.emailIsRequired ?? '';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return AppLocalizations.of(context)?.invalidEmail ?? '';
    } else {
      return null;
    }
  }

  static String? nameValidation(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)?.nameIsRequired ?? '';
    }
    if (value.trim().length < 4) {
      return AppLocalizations.of(context)?.nameAtLeast4Char;
    } else {
      return null;
    }
  }

  static String? passwordValidation(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)?.passwordIsRequired ?? '';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return AppLocalizations.of(
            context,
          )?.passwordShouldContainOneCapitalLetter ??
          '';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return AppLocalizations.of(context)?.passwordShouldContainOneNumber ?? '';
    }
    return null;
  }
}
