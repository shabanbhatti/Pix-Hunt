import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('ur'),
    Locale('zh'),
  ];

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @bookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmark;

  /// No description provided for @searchHistory.
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get searchHistory;

  /// No description provided for @downloadHistory.
  ///
  /// In en, this message translates to:
  /// **'Download History'**
  String get downloadHistory;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @updateEmail.
  ///
  /// In en, this message translates to:
  /// **'Update Email'**
  String get updateEmail;

  /// No description provided for @updateName.
  ///
  /// In en, this message translates to:
  /// **'Update Name'**
  String get updateName;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @newEmail.
  ///
  /// In en, this message translates to:
  /// **'New Email'**
  String get newEmail;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @imageTitle.
  ///
  /// In en, this message translates to:
  /// **'Image Title'**
  String get imageTitle;

  /// No description provided for @pixels.
  ///
  /// In en, this message translates to:
  /// **'Pixels'**
  String get pixels;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @doYouWantToDelete.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete?'**
  String get doYouWantToDelete;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @removeFromBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove from Bookmark'**
  String get removeFromBookmark;

  /// No description provided for @unbookmarkingMessage.
  ///
  /// In en, this message translates to:
  /// **'By removing from Bookmark, this item will be deleted from your Bookmarks.'**
  String get unbookmarkingMessage;

  /// No description provided for @noBookmarkItems.
  ///
  /// In en, this message translates to:
  /// **'No Bookmarks Yet'**
  String get noBookmarkItems;

  /// No description provided for @itemAddedToBookmark.
  ///
  /// In en, this message translates to:
  /// **'Item added to Bookmarks'**
  String get itemAddedToBookmark;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @pixels3k.
  ///
  /// In en, this message translates to:
  /// **'3k+ Pixels'**
  String get pixels3k;

  /// No description provided for @pixels800.
  ///
  /// In en, this message translates to:
  /// **'800 Pixels'**
  String get pixels800;

  /// No description provided for @pixels640.
  ///
  /// In en, this message translates to:
  /// **'640 Pixels'**
  String get pixels640;

  /// No description provided for @pixels400.
  ///
  /// In en, this message translates to:
  /// **'400 Pixels'**
  String get pixels400;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @photographer.
  ///
  /// In en, this message translates to:
  /// **'Photographer'**
  String get photographer;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @openImage.
  ///
  /// In en, this message translates to:
  /// **'Open Image'**
  String get openImage;

  /// No description provided for @changePicture.
  ///
  /// In en, this message translates to:
  /// **'Change Picture'**
  String get changePicture;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @goodNight.
  ///
  /// In en, this message translates to:
  /// **'Good Night'**
  String get goodNight;

  /// No description provided for @nature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get nature;

  /// No description provided for @village.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get village;

  /// No description provided for @universe.
  ///
  /// In en, this message translates to:
  /// **'Universe'**
  String get universe;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @motorcycles.
  ///
  /// In en, this message translates to:
  /// **'Motorcycles'**
  String get motorcycles;

  /// No description provided for @flowers.
  ///
  /// In en, this message translates to:
  /// **'Flowers'**
  String get flowers;

  /// No description provided for @forests.
  ///
  /// In en, this message translates to:
  /// **'Forests'**
  String get forests;

  /// No description provided for @oceans.
  ///
  /// In en, this message translates to:
  /// **'Oceans'**
  String get oceans;

  /// No description provided for @rivers.
  ///
  /// In en, this message translates to:
  /// **'Rivers'**
  String get rivers;

  /// No description provided for @wildlife.
  ///
  /// In en, this message translates to:
  /// **'Wildlife'**
  String get wildlife;

  /// No description provided for @cars.
  ///
  /// In en, this message translates to:
  /// **'Cars'**
  String get cars;

  /// No description provided for @animals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get animals;

  /// No description provided for @mysticPlaces.
  ///
  /// In en, this message translates to:
  /// **'Mystic Places'**
  String get mysticPlaces;

  /// No description provided for @historicalPlaces.
  ///
  /// In en, this message translates to:
  /// **'Historical Places'**
  String get historicalPlaces;

  /// No description provided for @mosque.
  ///
  /// In en, this message translates to:
  /// **'Mosque'**
  String get mosque;

  /// No description provided for @synagogue.
  ///
  /// In en, this message translates to:
  /// **'Synagogue'**
  String get synagogue;

  /// No description provided for @church.
  ///
  /// In en, this message translates to:
  /// **'Church'**
  String get church;

  /// No description provided for @mountains.
  ///
  /// In en, this message translates to:
  /// **'Mountains'**
  String get mountains;

  /// No description provided for @deserts.
  ///
  /// In en, this message translates to:
  /// **'Deserts'**
  String get deserts;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @waterfall.
  ///
  /// In en, this message translates to:
  /// **'Waterfall'**
  String get waterfall;

  /// No description provided for @searchContentHere.
  ///
  /// In en, this message translates to:
  /// **'Search content here'**
  String get searchContentHere;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @fieldShouldNotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Field should not be empty'**
  String get fieldShouldNotBeEmpty;

  /// No description provided for @thanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks'**
  String get thanks;

  /// No description provided for @forVisiting.
  ///
  /// In en, this message translates to:
  /// **'for visiting'**
  String get forVisiting;

  /// No description provided for @doYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout?'**
  String get doYouWantToLogout;

  /// No description provided for @noDownloads.
  ///
  /// In en, this message translates to:
  /// **'No Downloads'**
  String get noDownloads;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @imageSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery'**
  String get imageSavedToGallery;

  /// No description provided for @noSearchHistory.
  ///
  /// In en, this message translates to:
  /// **'No Search History'**
  String get noSearchHistory;

  /// No description provided for @nameUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Name updated successfully'**
  String get nameUpdatedSuccessfully;

  /// No description provided for @emailVerificationLink.
  ///
  /// In en, this message translates to:
  /// **'A verification link has been sent to your new email. Please verify.'**
  String get emailVerificationLink;

  /// No description provided for @searchResult.
  ///
  /// In en, this message translates to:
  /// **'Search Result'**
  String get searchResult;

  /// No description provided for @signingYouIn.
  ///
  /// In en, this message translates to:
  /// **'Signing you in...'**
  String get signingYouIn;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get createAccount;

  /// No description provided for @ifYouDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t have an account'**
  String get ifYouDontHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Login Your Account'**
  String get loginYourAccount;

  /// No description provided for @forgotYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Your Password?'**
  String get forgotYourPassword;

  /// No description provided for @forgotBtnDetail.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below and a password reset link will be sent to your email. You can reset your password using that link.'**
  String get forgotBtnDetail;

  /// No description provided for @createBtnDetail.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to enjoy high quality photos and download them instantly.'**
  String get createBtnDetail;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @sentLink.
  ///
  /// In en, this message translates to:
  /// **'Send Link'**
  String get sentLink;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @passwordResetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email (spam).'**
  String get passwordResetLinkSent;

  /// No description provided for @nameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameIsRequired;

  /// No description provided for @nameAtLeast4Char.
  ///
  /// In en, this message translates to:
  /// **'Name should be at lease 4 characters'**
  String get nameAtLeast4Char;

  /// No description provided for @passwordShouldContainOneCapitalLetter.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one capital letter'**
  String get passwordShouldContainOneCapitalLetter;

  /// No description provided for @passwordShouldContainOneNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get passwordShouldContainOneNumber;

  /// No description provided for @accountVerificationLinkSent.
  ///
  /// In en, this message translates to:
  /// **'An account verification link has been sent to your email (check SPAM folder). Please verify your email.'**
  String get accountVerificationLinkSent;

  /// No description provided for @passwordDoesntMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordDoesntMatch;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email is not verified! Please verify your email before login'**
  String get emailNotVerified;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'ur', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ur':
      return AppLocalizationsUr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
