import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
  ];

  /// No description provided for @startJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Spiritual Journey'**
  String get startJourney;

  /// No description provided for @exploreCategories.
  ///
  /// In en, this message translates to:
  /// **'Explore Categories'**
  String get exploreCategories;

  /// No description provided for @continuePractice.
  ///
  /// In en, this message translates to:
  /// **'Continue Practice'**
  String get continuePractice;

  /// No description provided for @findPeace.
  ///
  /// In en, this message translates to:
  /// **'Find peace and tranquility through daily dhikr, prayers, and spiritual practices.'**
  String get findPeace;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get greeting;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Almaathorat'**
  String get welcomeMessage;

  /// No description provided for @prayerTime.
  ///
  /// In en, this message translates to:
  /// **'Prayer Time'**
  String get prayerTime;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayer;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @chooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a category to start your spiritual practice'**
  String get chooseCategory;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @travelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Travel Prayers'**
  String get travelSubtitle;

  /// No description provided for @protection.
  ///
  /// In en, this message translates to:
  /// **'Protection'**
  String get protection;

  /// No description provided for @protectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Seeking Divine Protection'**
  String get protectionSubtitle;

  /// No description provided for @morningEvening.
  ///
  /// In en, this message translates to:
  /// **'Morning & Evening'**
  String get morningEvening;

  /// No description provided for @morningEveningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Adhkar'**
  String get morningEveningSubtitle;

  /// No description provided for @tasbih.
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get tasbih;

  /// No description provided for @tasbihSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Praise and Gratitude'**
  String get tasbihSubtitle;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;
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
      <String>['ar', 'en'].contains(locale.languageCode);

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
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
