import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_sw.dart';

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
    Locale('hi'),
    Locale('mr'),
    Locale('sw')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'PocketPlus'**
  String get appName;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessName;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @addFirstTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add your first transaction'**
  String get addFirstTransaction;

  /// No description provided for @dreamSavings.
  ///
  /// In en, this message translates to:
  /// **'Dream Savings'**
  String get dreamSavings;

  /// No description provided for @addMoneyToday.
  ///
  /// In en, this message translates to:
  /// **'How much have you added to your dream today?'**
  String get addMoneyToday;

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target Amount'**
  String get targetAmount;

  /// No description provided for @savedAmount.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedAmount;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'₹'**
  String get currencySymbol;

  /// No description provided for @phoneValidationError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get phoneValidationError;

  /// No description provided for @amountValidationError.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0'**
  String get amountValidationError;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selectCategory;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @phoneFormat.
  ///
  /// In en, this message translates to:
  /// **'Phone Format'**
  String get phoneFormat;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @countryChangeWarning.
  ///
  /// In en, this message translates to:
  /// **'Changing country will update your currency and phone format.'**
  String get countryChangeWarning;

  /// No description provided for @languageAndRegion.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get languageAndRegion;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorOccurred;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cantConnect.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server. Check your internet connection and try again.'**
  String get cantConnect;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep Editing'**
  String get keepEditing;

  /// No description provided for @newTransaction.
  ///
  /// In en, this message translates to:
  /// **'New Transaction'**
  String get newTransaction;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note (optional)'**
  String get addNote;

  /// No description provided for @holdToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Hold to speak'**
  String get holdToSpeak;

  /// No description provided for @scanBill.
  ///
  /// In en, this message translates to:
  /// **'Scan Bill'**
  String get scanBill;

  /// No description provided for @voiceInput.
  ///
  /// In en, this message translates to:
  /// **'Voice Input'**
  String get voiceInput;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'No Category'**
  String get noCategory;

  /// No description provided for @merchantName.
  ///
  /// In en, this message translates to:
  /// **'Merchant Name'**
  String get merchantName;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @totalExpense.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalExpense;

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalance;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get noTransactions;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

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

  /// No description provided for @businessOverview.
  ///
  /// In en, this message translates to:
  /// **'Business Overview'**
  String get businessOverview;

  /// No description provided for @secureApp.
  ///
  /// In en, this message translates to:
  /// **'100% Safe & Secure'**
  String get secureApp;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms & Privacy Policy'**
  String get agreeTerms;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Grow Your Business'**
  String get appTagline;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your business income & expenses'**
  String get appSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your username and password to sign in'**
  String get loginInstruction;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get usernameHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordTitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to start tracking your business'**
  String get createAccountSubtitle;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @signUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpLink;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLink;

  /// No description provided for @errorTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get errorTooManyAttempts;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Changes will sync when online.'**
  String get errorNoInternet;

  /// No description provided for @errorSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorSomethingWrong;

  /// No description provided for @errorAuthenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed.'**
  String get errorAuthenticationFailed;

  /// No description provided for @errorUsernameTaken.
  ///
  /// In en, this message translates to:
  /// **'This username is already taken.'**
  String get errorUsernameTaken;

  /// No description provided for @errorUsernameNotFound.
  ///
  /// In en, this message translates to:
  /// **'Username not found.'**
  String get errorUsernameNotFound;

  /// No description provided for @errorIncorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get errorIncorrectPassword;

  /// No description provided for @errorInvalidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get errorInvalidEmailAddress;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters with uppercase, lowercase, and a number.'**
  String get errorWeakPassword;

  /// No description provided for @errorEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get errorEmailAlreadyInUse;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactionsFound;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by merchant, note, or amount...'**
  String get searchHint;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undo;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found.'**
  String get noCategoriesFound;

  /// No description provided for @discardChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardChangesTitle;

  /// No description provided for @discardChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to discard your edits?'**
  String get discardChangesMessage;

  /// No description provided for @microphonePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission required for voice entry'**
  String get microphonePermissionRequired;

  /// No description provided for @microphonePermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission permanently denied. Enable in Settings.'**
  String get microphonePermissionPermanentlyDenied;

  /// No description provided for @settingsButton.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsButton;

  /// No description provided for @foreignCurrencyDetected.
  ///
  /// In en, this message translates to:
  /// **'Foreign Currency Detected'**
  String get foreignCurrencyDetected;

  /// No description provided for @foreignCurrency.
  ///
  /// In en, this message translates to:
  /// **'foreign currency'**
  String get foreignCurrency;

  /// No description provided for @foreignCurrencyConvertMessage.
  ///
  /// In en, this message translates to:
  /// **'This appears to be in {currency}. Convert to INR?'**
  String foreignCurrencyConvertMessage(Object currency);

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @futureDatesNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Future dates not allowed.'**
  String get futureDatesNotAllowed;

  /// No description provided for @speechError.
  ///
  /// In en, this message translates to:
  /// **'Speech error: {error}'**
  String speechError(Object error);

  /// No description provided for @couldNotInitializeSpeech.
  ///
  /// In en, this message translates to:
  /// **'Could not initialize speech recognition.'**
  String get couldNotInitializeSpeech;

  /// No description provided for @couldNotUnderstand.
  ///
  /// In en, this message translates to:
  /// **'Could not understand. Try again or enter manually.'**
  String get couldNotUnderstand;

  /// No description provided for @couldNotProcessVoice.
  ///
  /// In en, this message translates to:
  /// **'Could not process voice. Please enter manually.'**
  String get couldNotProcessVoice;

  /// No description provided for @enterAmountAndCategory.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount and select a category.'**
  String get enterAmountAndCategory;

  /// No description provided for @amountExceedsMax.
  ///
  /// In en, this message translates to:
  /// **'Amount must be less than ₹10,00,000.'**
  String get amountExceedsMax;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User or profile not logged in.'**
  String get userNotLoggedIn;

  /// No description provided for @cameraAccessFailed.
  ///
  /// In en, this message translates to:
  /// **'Camera access failed.'**
  String get cameraAccessFailed;

  /// No description provided for @couldNotReadAmount.
  ///
  /// In en, this message translates to:
  /// **'Could not read amount — enter manually'**
  String get couldNotReadAmount;

  /// No description provided for @couldNotReadBill.
  ///
  /// In en, this message translates to:
  /// **'Could not read bill — enter manually'**
  String get couldNotReadBill;

  /// No description provided for @noReceiptFound.
  ///
  /// In en, this message translates to:
  /// **'No receipt found in photo'**
  String get noReceiptFound;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @transactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(Object message);

  /// No description provided for @transactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Transaction not found.'**
  String get transactionNotFound;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @incomeUppercase.
  ///
  /// In en, this message translates to:
  /// **'INCOME'**
  String get incomeUppercase;

  /// No description provided for @expenseUppercase.
  ///
  /// In en, this message translates to:
  /// **'EXPENSE'**
  String get expenseUppercase;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @auditComments.
  ///
  /// In en, this message translates to:
  /// **'Audit Comments'**
  String get auditComments;

  /// No description provided for @flagged.
  ///
  /// In en, this message translates to:
  /// **'FLAGGED'**
  String get flagged;

  /// No description provided for @resolvedStatus.
  ///
  /// In en, this message translates to:
  /// **'RESOLVED'**
  String get resolvedStatus;

  /// No description provided for @noReviewComments.
  ///
  /// In en, this message translates to:
  /// **'No review comments.'**
  String get noReviewComments;

  /// No description provided for @charteredAccountant.
  ///
  /// In en, this message translates to:
  /// **'Chartered Accountant'**
  String get charteredAccountant;

  /// No description provided for @resolvedLabel.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolvedLabel;

  /// No description provided for @resolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolve;

  /// No description provided for @flagForReview.
  ///
  /// In en, this message translates to:
  /// **'Flag for Review'**
  String get flagForReview;

  /// No description provided for @totalIncomeSelected.
  ///
  /// In en, this message translates to:
  /// **'Total Income Selected'**
  String get totalIncomeSelected;

  /// No description provided for @totalExpensesSelected.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses Selected'**
  String get totalExpensesSelected;

  /// No description provided for @countSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String countSelected(Object count);

  /// No description provided for @totalCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Total copied to clipboard'**
  String get totalCopiedToClipboard;

  /// No description provided for @incomePrefixPlus.
  ///
  /// In en, this message translates to:
  /// **'Income: +'**
  String get incomePrefixPlus;

  /// No description provided for @expensesPrefixMinus.
  ///
  /// In en, this message translates to:
  /// **'Expenses: -'**
  String get expensesPrefixMinus;

  /// No description provided for @netPrefix.
  ///
  /// In en, this message translates to:
  /// **'Net: '**
  String get netPrefix;

  /// No description provided for @transactionCountOne.
  ///
  /// In en, this message translates to:
  /// **'1 transaction'**
  String get transactionCountOne;

  /// No description provided for @transactionCountMany.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String transactionCountMany(Object count);

  /// No description provided for @shareSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'PocketPlus Summary'**
  String get shareSummaryTitle;

  /// No description provided for @shareIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Income: '**
  String get shareIncomeLabel;

  /// No description provided for @shareExpensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Expenses: '**
  String get shareExpensesLabel;

  /// No description provided for @shareNetLabel.
  ///
  /// In en, this message translates to:
  /// **'Net: '**
  String get shareNetLabel;

  /// No description provided for @shareFromBusiness.
  ///
  /// In en, this message translates to:
  /// **'— {businessName}'**
  String shareFromBusiness(Object businessName);

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @khataLedger.
  ///
  /// In en, this message translates to:
  /// **'Khata Ledger'**
  String get khataLedger;

  /// No description provided for @smsAutoCaptureActive.
  ///
  /// In en, this message translates to:
  /// **'SMS Auto-Capture Active'**
  String get smsAutoCaptureActive;

  /// No description provided for @autoLoggingBankAlerts.
  ///
  /// In en, this message translates to:
  /// **'Auto-logging bank transaction alerts'**
  String get autoLoggingBankAlerts;

  /// No description provided for @planYourFinancialDreams.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Financial Dreams'**
  String get planYourFinancialDreams;

  /// No description provided for @setGoalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set goals for vehicles, shops, expansion'**
  String get setGoalsSubtitle;

  /// No description provided for @savingsGoal.
  ///
  /// In en, this message translates to:
  /// **'SAVINGS GOAL'**
  String get savingsGoal;

  /// No description provided for @savedOfTarget.
  ///
  /// In en, this message translates to:
  /// **'{saved} saved of {target}'**
  String savedOfTarget(Object saved, Object target);

  /// No description provided for @currentMonthNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Current Month Net Profit'**
  String get currentMonthNetProfit;

  /// No description provided for @changePercentVsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'{changePercent}% vs last month'**
  String changePercentVsLastMonth(Object changePercent);

  /// No description provided for @todaysIncome.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S INCOME'**
  String get todaysIncome;

  /// No description provided for @todaysExpense.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S EXPENSE'**
  String get todaysExpense;

  /// No description provided for @chartAccessibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly performance bar chart showing {details}'**
  String chartAccessibilityLabel(Object details);

  /// No description provided for @performanceTrend.
  ///
  /// In en, this message translates to:
  /// **'PERFORMANCE TREND'**
  String get performanceTrend;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get netProfit;

  /// No description provided for @recentEntries.
  ///
  /// In en, this message translates to:
  /// **'RECENT ENTRIES'**
  String get recentEntries;

  /// No description provided for @addTxnsForReportSummary.
  ///
  /// In en, this message translates to:
  /// **'Add income or expenses to see report summary'**
  String get addTxnsForReportSummary;

  /// No description provided for @clientBooks.
  ///
  /// In en, this message translates to:
  /// **'Client Books'**
  String get clientBooks;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @switchProfile.
  ///
  /// In en, this message translates to:
  /// **'Switch Profile'**
  String get switchProfile;

  /// No description provided for @tutorialStepCounter.
  ///
  /// In en, this message translates to:
  /// **'Step {stepNumber} of {totalSteps}'**
  String tutorialStepCounter(Object stepNumber, Object totalSteps);

  /// No description provided for @khata.
  ///
  /// In en, this message translates to:
  /// **'Khata'**
  String get khata;

  /// No description provided for @addFirstCreditCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add your first credit customer'**
  String get addFirstCreditCustomer;

  /// No description provided for @addCustomerButton.
  ///
  /// In en, this message translates to:
  /// **'+ Add Customer'**
  String get addCustomerButton;

  /// No description provided for @customerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Customer not found'**
  String get customerNotFound;

  /// No description provided for @customerOwesYou.
  ///
  /// In en, this message translates to:
  /// **'Customer owes you'**
  String get customerOwesYou;

  /// No description provided for @youOweCustomer.
  ///
  /// In en, this message translates to:
  /// **'You owe customer'**
  String get youOweCustomer;

  /// No description provided for @settled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settled;

  /// No description provided for @giveCredit.
  ///
  /// In en, this message translates to:
  /// **'Give Credit'**
  String get giveCredit;

  /// No description provided for @recordRepayment.
  ///
  /// In en, this message translates to:
  /// **'Record Repayment'**
  String get recordRepayment;

  /// No description provided for @whatsappReminder.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Reminder'**
  String get whatsappReminder;

  /// No description provided for @noEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get noEntriesYet;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @whatsappReminderTemplate.
  ///
  /// In en, this message translates to:
  /// **'Namaste {customerName}, your outstanding balance is {balance}. — {businessName}'**
  String whatsappReminderTemplate(
      Object balance, Object businessName, Object customerName);

  /// No description provided for @creditGiven.
  ///
  /// In en, this message translates to:
  /// **'Credit given'**
  String get creditGiven;

  /// No description provided for @repaymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Repayment received'**
  String get repaymentReceived;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @customerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get customerNameHint;

  /// No description provided for @phoneOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptionalLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit Indian number'**
  String get phoneHint;

  /// No description provided for @noteOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptionalHint;

  /// No description provided for @nameMinLengthError.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters.'**
  String get nameMinLengthError;

  /// No description provided for @nameMaxLengthError.
  ///
  /// In en, this message translates to:
  /// **'Name must be at most 200 characters.'**
  String get nameMaxLengthError;

  /// No description provided for @amountRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Amount is required.'**
  String get amountRequiredError;

  /// No description provided for @invalidAmountError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount (> 0, max ₹1,00,000).'**
  String get invalidAmountError;

  /// No description provided for @couldNotSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save. Please try again.'**
  String get couldNotSaveError;

  /// No description provided for @failedToCreateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Failed to create khata customer.'**
  String get failedToCreateCustomer;

  /// No description provided for @failedToRecordCredit.
  ///
  /// In en, this message translates to:
  /// **'Failed to record credit entry.'**
  String get failedToRecordCredit;

  /// No description provided for @failedToRecordRepayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to record repayment entry.'**
  String get failedToRecordRepayment;

  /// No description provided for @failedToDeleteCustomer.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete khata customer.'**
  String get failedToDeleteCustomer;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @addTxnsForInsights.
  ///
  /// In en, this message translates to:
  /// **'Add transactions to see report insights'**
  String get addTxnsForInsights;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @viewAiInsights.
  ///
  /// In en, this message translates to:
  /// **'View AI Insights'**
  String get viewAiInsights;

  /// No description provided for @failedToLoadAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Failed to load analytics data. Please try again.'**
  String get failedToLoadAnalytics;

  /// No description provided for @totalNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Total Net Profit'**
  String get totalNetProfit;

  /// No description provided for @bestMonth.
  ///
  /// In en, this message translates to:
  /// **'BEST MONTH'**
  String get bestMonth;

  /// No description provided for @worstMonth.
  ///
  /// In en, this message translates to:
  /// **'WORST MONTH'**
  String get worstMonth;

  /// No description provided for @avgMonthly.
  ///
  /// In en, this message translates to:
  /// **'AVG MONTHLY'**
  String get avgMonthly;

  /// No description provided for @lastXMonths.
  ///
  /// In en, this message translates to:
  /// **'Last {count} months'**
  String lastXMonths(Object count);

  /// No description provided for @momGrowth.
  ///
  /// In en, this message translates to:
  /// **'MoM GROWTH'**
  String get momGrowth;

  /// No description provided for @lookingGood.
  ///
  /// In en, this message translates to:
  /// **'Looking good!'**
  String get lookingGood;

  /// No description provided for @needsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get needsAttention;

  /// No description provided for @pro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get pro;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @successfullySubscribed.
  ///
  /// In en, this message translates to:
  /// **'Successfully subscribed to {planName}!'**
  String successfullySubscribed(Object planName);

  /// No description provided for @basicPriceFallback.
  ///
  /// In en, this message translates to:
  /// **'₹100/month'**
  String get basicPriceFallback;

  /// No description provided for @proPriceFallback.
  ///
  /// In en, this message translates to:
  /// **'₹200/month'**
  String get proPriceFallback;

  /// No description provided for @upgradeAccount.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Account'**
  String get upgradeAccount;

  /// No description provided for @chooseYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get chooseYourPlan;

  /// No description provided for @upgradeDescription.
  ///
  /// In en, this message translates to:
  /// **'Unlock advanced features to scale your ledger tracking'**
  String get upgradeDescription;

  /// No description provided for @basicPlan.
  ///
  /// In en, this message translates to:
  /// **'Basic Plan'**
  String get basicPlan;

  /// No description provided for @featureMultipleProfiles.
  ///
  /// In en, this message translates to:
  /// **'Multiple Profiles (up to 3)'**
  String get featureMultipleProfiles;

  /// No description provided for @featureFiveInvoices.
  ///
  /// In en, this message translates to:
  /// **'5 Invoices per month'**
  String get featureFiveInvoices;

  /// No description provided for @featureFivePdfExports.
  ///
  /// In en, this message translates to:
  /// **'5 PDF Exports per month'**
  String get featureFivePdfExports;

  /// No description provided for @featureOfflineCapabilities.
  ///
  /// In en, this message translates to:
  /// **'Offline capabilities'**
  String get featureOfflineCapabilities;

  /// No description provided for @proPlan.
  ///
  /// In en, this message translates to:
  /// **'Pro Plan'**
  String get proPlan;

  /// No description provided for @featureUnlimitedProfiles.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Profiles'**
  String get featureUnlimitedProfiles;

  /// No description provided for @featureUnlimitedInvoices.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Invoices'**
  String get featureUnlimitedInvoices;

  /// No description provided for @featureUnlimitedPdfExports.
  ///
  /// In en, this message translates to:
  /// **'Unlimited PDF Exports'**
  String get featureUnlimitedPdfExports;

  /// No description provided for @featureCaConnect.
  ///
  /// In en, this message translates to:
  /// **'CA Connect integration'**
  String get featureCaConnect;

  /// No description provided for @featureAiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights & Voice logging'**
  String get featureAiInsights;

  /// No description provided for @featurePrioritySupport.
  ///
  /// In en, this message translates to:
  /// **'Priority support'**
  String get featurePrioritySupport;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Already subscribed? Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @bestValue.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get bestValue;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @processingLabel.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processingLabel;

  /// No description provided for @subscribeWithPrice.
  ///
  /// In en, this message translates to:
  /// **'Subscribe {price}'**
  String subscribeWithPrice(Object price);

  /// No description provided for @purchaseFailedError.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get purchaseFailedError;

  /// No description provided for @verificationFailedError.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailedError;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @errorInvalidEmailLink.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired sign-in link. Please request a new one.'**
  String get errorInvalidEmailLink;

  /// No description provided for @mlInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'ML Insights'**
  String get mlInsightsTitle;

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'PocketPlus Notifications'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Main notification channel for PocketPlus updates'**
  String get notificationChannelDescription;

  /// No description provided for @caConnect.
  ///
  /// In en, this message translates to:
  /// **'CA Connect'**
  String get caConnect;

  /// No description provided for @caInvitation.
  ///
  /// In en, this message translates to:
  /// **'CA Invitation'**
  String get caInvitation;

  /// No description provided for @myClients.
  ///
  /// In en, this message translates to:
  /// **'My Clients'**
  String get myClients;

  /// No description provided for @proFeature.
  ///
  /// In en, this message translates to:
  /// **'Pro Feature'**
  String get proFeature;

  /// No description provided for @caConnectProPrompt.
  ///
  /// In en, this message translates to:
  /// **'CA Connect is a Pro feature. Upgrade for ₹200/month.'**
  String get caConnectProPrompt;

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradeToPro;

  /// No description provided for @inviteCaTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite your CA to get live access to your books'**
  String get inviteCaTitle;

  /// No description provided for @caConnectDescription.
  ///
  /// In en, this message translates to:
  /// **'Once accepted, your CA can review transactions and post queries directly here.'**
  String get caConnectDescription;

  /// No description provided for @caPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'CA Phone Number *'**
  String get caPhoneLabel;

  /// No description provided for @sendWhatsappInvite.
  ///
  /// In en, this message translates to:
  /// **'Send WhatsApp Invite'**
  String get sendWhatsappInvite;

  /// No description provided for @inviteSentTo.
  ///
  /// In en, this message translates to:
  /// **'Invite sent to +91 {phone}'**
  String inviteSentTo(Object phone);

  /// No description provided for @waitingForCaAccept.
  ///
  /// In en, this message translates to:
  /// **'Waiting for CA to accept...'**
  String get waitingForCaAccept;

  /// No description provided for @resendInvite.
  ///
  /// In en, this message translates to:
  /// **'Resend Invite'**
  String get resendInvite;

  /// No description provided for @cancelInvite.
  ///
  /// In en, this message translates to:
  /// **'Cancel Invite'**
  String get cancelInvite;

  /// No description provided for @manageCaAccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your accountant\'s access and view their feedback securely.'**
  String get manageCaAccessSubtitle;

  /// No description provided for @recentCaComments.
  ///
  /// In en, this message translates to:
  /// **'Recent CA Comments'**
  String get recentCaComments;

  /// No description provided for @errorLoadingComments.
  ///
  /// In en, this message translates to:
  /// **'Error loading comments: {error}'**
  String errorLoadingComments(Object error);

  /// No description provided for @revokeAccess.
  ///
  /// In en, this message translates to:
  /// **'Revoke Access'**
  String get revokeAccess;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @lastViewed.
  ///
  /// In en, this message translates to:
  /// **'Last viewed: {time}'**
  String lastViewed(Object time);

  /// No description provided for @whatCaCanSee.
  ///
  /// In en, this message translates to:
  /// **'What your CA can see'**
  String get whatCaCanSee;

  /// No description provided for @accessControlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control which data sets are shared for auditing.'**
  String get accessControlSubtitle;

  /// No description provided for @salesAndIncome.
  ///
  /// In en, this message translates to:
  /// **'Sales & Income'**
  String get salesAndIncome;

  /// No description provided for @salesIncomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Invoices, received payments, and daily sales.'**
  String get salesIncomeDescription;

  /// No description provided for @expensesAndPurchases.
  ///
  /// In en, this message translates to:
  /// **'Expenses & Purchases'**
  String get expensesAndPurchases;

  /// No description provided for @expensesPurchasesDescription.
  ///
  /// In en, this message translates to:
  /// **'Bills, supplier payments, and overheads.'**
  String get expensesPurchasesDescription;

  /// No description provided for @taxReports.
  ///
  /// In en, this message translates to:
  /// **'Tax Reports'**
  String get taxReports;

  /// No description provided for @taxReportsDescription.
  ///
  /// In en, this message translates to:
  /// **'GST summaries and automated tax calculations.'**
  String get taxReportsDescription;

  /// No description provided for @noUnresolvedComments.
  ///
  /// In en, this message translates to:
  /// **'No unresolved comments from CA.'**
  String get noUnresolvedComments;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @viewTransaction.
  ///
  /// In en, this message translates to:
  /// **'View Transaction'**
  String get viewTransaction;

  /// No description provided for @ownersBooks.
  ///
  /// In en, this message translates to:
  /// **'{ownerName}\'s Books'**
  String ownersBooks(Object ownerName);

  /// No description provided for @caViewReadOnly.
  ///
  /// In en, this message translates to:
  /// **'CA View — Read Only'**
  String get caViewReadOnly;

  /// No description provided for @errorLoadingTransactions.
  ///
  /// In en, this message translates to:
  /// **'Error loading transactions: {error}'**
  String errorLoadingTransactions(Object error);

  /// No description provided for @noTransactionsForClient.
  ///
  /// In en, this message translates to:
  /// **'No transactions recorded for this client.'**
  String get noTransactionsForClient;

  /// No description provided for @failedToSubmitComment.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit comment: {message}'**
  String failedToSubmitComment(Object message);

  /// No description provided for @commentSentToOwner.
  ///
  /// In en, this message translates to:
  /// **'Comment sent to {ownerName}'**
  String commentSentToOwner(Object ownerName);

  /// No description provided for @addCommentInstruction.
  ///
  /// In en, this message translates to:
  /// **'Add a comment for the owner to review.'**
  String get addCommentInstruction;

  /// No description provided for @flagDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe why this transaction is flagged...'**
  String get flagDescriptionHint;

  /// No description provided for @commentRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Comment is required'**
  String get commentRequiredError;

  /// No description provided for @commentMinLengthError.
  ///
  /// In en, this message translates to:
  /// **'Comment must be at least 10 characters long'**
  String get commentMinLengthError;

  /// No description provided for @pendingInvitationExists.
  ///
  /// In en, this message translates to:
  /// **'A pending or active invitation already exists'**
  String get pendingInvitationExists;

  /// No description provided for @caInviteWhatsappMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi, I\'m inviting you to view my PocketPlus books. Accept here: https://pocketplus.app/ca/accept?token={token}'**
  String caInviteWhatsappMessage(Object token);

  /// No description provided for @couldNotOpenWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp.'**
  String get couldNotOpenWhatsapp;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes ago'**
  String minutesAgo(Object minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String hoursAgo(Object hours);

  /// No description provided for @whatsappQuestionTemplate.
  ///
  /// In en, this message translates to:
  /// **'Hi, I have a question about my books on PocketPlus.'**
  String get whatsappQuestionTemplate;

  /// No description provided for @noActiveClientConnections.
  ///
  /// In en, this message translates to:
  /// **'No active client connections.'**
  String get noActiveClientConnections;

  /// No description provided for @businessBooks.
  ///
  /// In en, this message translates to:
  /// **'Business Books'**
  String get businessBooks;

  /// No description provided for @lastActiveDatetime.
  ///
  /// In en, this message translates to:
  /// **'Last active: {datetime}'**
  String lastActiveDatetime(Object datetime);

  /// No description provided for @lastActiveNever.
  ///
  /// In en, this message translates to:
  /// **'Last active: Never'**
  String get lastActiveNever;

  /// No description provided for @inviteExpiredOrInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invite expired or invalid.'**
  String get inviteExpiredOrInvalid;

  /// No description provided for @inviteExpiredInstructions.
  ///
  /// In en, this message translates to:
  /// **'This invite link has expired or is invalid. Ask your client to resend.'**
  String get inviteExpiredInstructions;

  /// No description provided for @alreadyConnectedRedirecting.
  ///
  /// In en, this message translates to:
  /// **'Already connected! Redirecting...'**
  String get alreadyConnectedRedirecting;

  /// No description provided for @authenticationRequired.
  ///
  /// In en, this message translates to:
  /// **'Authentication Required'**
  String get authenticationRequired;

  /// No description provided for @loginToAcceptInvitation.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view and accept this invitation.'**
  String get loginToAcceptInvitation;

  /// No description provided for @invitePhoneMismatch.
  ///
  /// In en, this message translates to:
  /// **'This invite was not sent to your number.'**
  String get invitePhoneMismatch;

  /// No description provided for @invitePhoneMismatchInstructions.
  ///
  /// In en, this message translates to:
  /// **'This invite was sent to a different phone number. Ask your client to resend.'**
  String get invitePhoneMismatchInstructions;

  /// No description provided for @inviteDescriptionAsCa.
  ///
  /// In en, this message translates to:
  /// **'You have been invited to view {ownerName}\'s books as their Chartered Accountant.'**
  String inviteDescriptionAsCa(Object ownerName);

  /// No description provided for @acceptInvitation.
  ///
  /// In en, this message translates to:
  /// **'Accept Invitation'**
  String get acceptInvitation;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @caConnectProFeatureError.
  ///
  /// In en, this message translates to:
  /// **'CA Connect is a Pro feature. Upgrade to Pro.'**
  String get caConnectProFeatureError;

  /// No description provided for @cannotInviteOwnNumber.
  ///
  /// In en, this message translates to:
  /// **'Cannot invite your own number.'**
  String get cannotInviteOwnNumber;

  /// No description provided for @firestoreError.
  ///
  /// In en, this message translates to:
  /// **'Firestore error'**
  String get firestoreError;

  /// No description provided for @sessionExpiredError.
  ///
  /// In en, this message translates to:
  /// **'User is not logged in. Session expired.'**
  String get sessionExpiredError;

  /// No description provided for @failedToCreateCategory.
  ///
  /// In en, this message translates to:
  /// **'Failed to create category in Firestore.'**
  String get failedToCreateCategory;

  /// No description provided for @failedToDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete category in Firestore.'**
  String get failedToDeleteCategory;

  /// No description provided for @failedToSeedCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to seed categories in Firestore.'**
  String get failedToSeedCategories;

  /// No description provided for @revoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get revoke;

  /// No description provided for @revokeCaAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke CA Access?'**
  String get revokeCaAccessTitle;

  /// No description provided for @revokeCaAccessConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? {caName} will immediately lose access to your books.'**
  String revokeCaAccessConfirmation(Object caName);

  /// No description provided for @invalidMobileNumberError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number.'**
  String get invalidMobileNumberError;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Please select a role.'**
  String get selectRole;

  /// No description provided for @businessNameLength.
  ///
  /// In en, this message translates to:
  /// **'Business name must be between 2 and 200 characters.'**
  String get businessNameLength;

  /// No description provided for @nameLength2to100.
  ///
  /// In en, this message translates to:
  /// **'Name must be 2-100 characters'**
  String get nameLength2to100;

  /// No description provided for @targetDateFuture.
  ///
  /// In en, this message translates to:
  /// **'Target date must be in the future'**
  String get targetDateFuture;

  /// No description provided for @invalidTargetAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid target amount'**
  String get invalidTargetAmount;

  /// No description provided for @noActiveProfile.
  ///
  /// In en, this message translates to:
  /// **'No active profile found.'**
  String get noActiveProfile;

  /// No description provided for @amountRequiredGeneric.
  ///
  /// In en, this message translates to:
  /// **'Amount is required.'**
  String get amountRequiredGeneric;

  /// No description provided for @invalidAmountGeneric.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount.'**
  String get invalidAmountGeneric;

  /// No description provided for @amountExceedsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot exceed your remaining goal'**
  String get amountExceedsRemaining;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description required.'**
  String get descriptionRequired;

  /// No description provided for @watchAdToCreateInvoice.
  ///
  /// In en, this message translates to:
  /// **'Watch the full ad to create invoice'**
  String get watchAdToCreateInvoice;

  /// No description provided for @watchAdToExport.
  ///
  /// In en, this message translates to:
  /// **'Watch the full ad to export'**
  String get watchAdToExport;

  /// No description provided for @activeProfileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Active profile not found.'**
  String get activeProfileNotFound;

  /// No description provided for @orSeparator.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orSeparator;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired.'**
  String get sessionExpired;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @exitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exitAppTitle;

  /// No description provided for @exitAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit the app?'**
  String get exitAppMessage;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get appLock;

  /// No description provided for @appLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require a PIN or biometric to open the app'**
  String get appLockSubtitle;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @enterYourPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get enterYourPin;

  /// No description provided for @incorrectPinTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. Try again.'**
  String get incorrectPinTryAgain;

  /// No description provided for @unlockWithBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Unlock with biometrics'**
  String get unlockWithBiometrics;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @setAppPin.
  ///
  /// In en, this message translates to:
  /// **'Set app PIN'**
  String get setAppPin;

  /// No description provided for @chooseFourDigitPin.
  ///
  /// In en, this message translates to:
  /// **'Choose a 4-digit PIN'**
  String get chooseFourDigitPin;

  /// No description provided for @confirmYourPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN'**
  String get confirmYourPin;

  /// No description provided for @pinsDidntMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs didn\'t match. Start again.'**
  String get pinsDidntMatch;

  /// No description provided for @enableBiometricTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable biometric unlock?'**
  String get enableBiometricTitle;

  /// No description provided for @enableBiometricBody.
  ///
  /// In en, this message translates to:
  /// **'Use your fingerprint or face to unlock PocketPlus instead of typing your PIN each time.'**
  String get enableBiometricBody;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @appLockEnabled.
  ///
  /// In en, this message translates to:
  /// **'App lock enabled.'**
  String get appLockEnabled;

  /// No description provided for @appLockTurnedOff.
  ///
  /// In en, this message translates to:
  /// **'App lock turned off.'**
  String get appLockTurnedOff;

  /// No description provided for @enterPinToTurnOff.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN to turn off App Lock'**
  String get enterPinToTurnOff;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @turnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get turnOff;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get sectionAccount;

  /// No description provided for @sectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get sectionPreferences;

  /// No description provided for @sectionSmsCapture.
  ///
  /// In en, this message translates to:
  /// **'SMS Capture'**
  String get sectionSmsCapture;

  /// No description provided for @sectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get sectionSupport;

  /// No description provided for @sectionDataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get sectionDataPrivacy;

  /// No description provided for @sectionAppInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get sectionAppInfo;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @fiscalYearStart.
  ///
  /// In en, this message translates to:
  /// **'Fiscal Year Start'**
  String get fiscalYearStart;

  /// No description provided for @monthApril.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApril;

  /// No description provided for @monthJanuary.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJanuary;

  /// No description provided for @smsAutoCapture.
  ///
  /// In en, this message translates to:
  /// **'SMS Auto-Capture'**
  String get smsAutoCapture;

  /// No description provided for @smsAutoCaptureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-log bank transaction alerts'**
  String get smsAutoCaptureSubtitle;

  /// No description provided for @replayTutorial.
  ///
  /// In en, this message translates to:
  /// **'Replay Onboarding Tutorial'**
  String get replayTutorial;

  /// No description provided for @replayTutorialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reset onboarding tips and run the tour again'**
  String get replayTutorialSubtitle;

  /// No description provided for @onboardingTutorialReset.
  ///
  /// In en, this message translates to:
  /// **'Onboarding tutorial reset.'**
  String get onboardingTutorialReset;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @rateOnPlayStore.
  ///
  /// In en, this message translates to:
  /// **'Rate PocketPlus on Play Store'**
  String get rateOnPlayStore;

  /// No description provided for @exportMyData.
  ///
  /// In en, this message translates to:
  /// **'Export My Data'**
  String get exportMyData;

  /// No description provided for @exportMyDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download all your data as JSON'**
  String get exportMyDataSubtitle;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Soft delete with 30-day grace period'**
  String get deleteAccountSubtitle;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingLabel;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Your data will be soft-deleted with a 30-day grace period. During this time, you can contact support to restore your account. After 30 days, all data will be permanently removed.'**
  String get deleteAccountBody;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @typeDeleteToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE to confirm'**
  String get typeDeleteToConfirm;

  /// No description provided for @typeDeleteHint.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE'**
  String get typeDeleteHint;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @budgetOverview.
  ///
  /// In en, this message translates to:
  /// **'Budget Overview'**
  String get budgetOverview;

  /// No description provided for @expensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesLabel;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exporting;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @noTransactionsForPeriod.
  ///
  /// In en, this message translates to:
  /// **'No transactions exist for selected period'**
  String get noTransactionsForPeriod;

  /// No description provided for @noTransactionsInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No transactions in this period.'**
  String get noTransactionsInPeriod;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @unaccounted.
  ///
  /// In en, this message translates to:
  /// **'Unaccounted'**
  String get unaccounted;

  /// No description provided for @viewFullHistory.
  ///
  /// In en, this message translates to:
  /// **'View full transaction history'**
  String get viewFullHistory;

  /// No description provided for @createBudget.
  ///
  /// In en, this message translates to:
  /// **'Create Budget'**
  String get createBudget;

  /// No description provided for @noBudgetsMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'No budgets match this filter'**
  String get noBudgetsMatchFilter;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @budgetNotFound.
  ///
  /// In en, this message translates to:
  /// **'Budget not found'**
  String get budgetNotFound;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @dailyAvg.
  ///
  /// In en, this message translates to:
  /// **'Daily Avg'**
  String get dailyAvg;

  /// No description provided for @weeklyAvg.
  ///
  /// In en, this message translates to:
  /// **'Weekly Avg'**
  String get weeklyAvg;

  /// No description provided for @forecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get forecast;

  /// No description provided for @largestExpense.
  ///
  /// In en, this message translates to:
  /// **'Largest Expense'**
  String get largestExpense;

  /// No description provided for @mostFrequent.
  ///
  /// In en, this message translates to:
  /// **'Most Frequent'**
  String get mostFrequent;

  /// No description provided for @transactionsCount.
  ///
  /// In en, this message translates to:
  /// **'Transactions ({count})'**
  String transactionsCount(int count);

  /// No description provided for @noTransactionsYetBudget.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet for this budget'**
  String get noTransactionsYetBudget;

  /// No description provided for @categoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Category Breakdown'**
  String get categoryBreakdown;

  /// No description provided for @mostExpensiveDay.
  ///
  /// In en, this message translates to:
  /// **'Most Expensive Day'**
  String get mostExpensiveDay;

  /// No description provided for @averageDailySpending.
  ///
  /// In en, this message translates to:
  /// **'Average Daily Spending'**
  String get averageDailySpending;

  /// No description provided for @deleteBudget.
  ///
  /// In en, this message translates to:
  /// **'Delete Budget'**
  String get deleteBudget;

  /// No description provided for @areYouSureUndone.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? This action cannot be undone.'**
  String get areYouSureUndone;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit Budget'**
  String get editBudget;

  /// No description provided for @budgetName.
  ///
  /// In en, this message translates to:
  /// **'Budget Name'**
  String get budgetName;

  /// No description provided for @amountRupees.
  ///
  /// In en, this message translates to:
  /// **'Amount (₹)'**
  String get amountRupees;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @alertAtPercent.
  ///
  /// In en, this message translates to:
  /// **'Alert at {percent}%'**
  String alertAtPercent(int percent);

  /// No description provided for @updateBudget.
  ///
  /// In en, this message translates to:
  /// **'Update Budget'**
  String get updateBudget;

  /// No description provided for @budgetNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Monthly Groceries'**
  String get budgetNameHint;

  /// No description provided for @amountHintExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10000'**
  String get amountHintExample;
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
      <String>['ar', 'en', 'hi', 'mr', 'sw'].contains(locale.languageCode);

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
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
