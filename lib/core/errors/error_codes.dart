abstract final class ErrorCodes {
  static const String tooManyAttempts = 'tooManyAttempts';
  static const String sessionExpired = 'sessionExpired';
  static const String authenticationFailed = 'authenticationFailed';
  static const String usernameTaken = 'usernameTaken';
  static const String usernameNotFound = 'usernameNotFound';
  static const String incorrectPassword = 'incorrectPassword';
  static const String invalidEmail = 'invalidEmail';
  static const String weakPassword = 'weakPassword';
  static const String emailAlreadyInUse = 'emailAlreadyInUse';

  static const String networkError = 'networkError';
  static const String somethingWrong = 'somethingWrong';
  static const String firestoreError = 'firestoreError';

  static const String inviteExpired = 'inviteExpired';
  static const String phoneMismatch = 'phoneMismatch';
  static const String pendingInvitation = 'pendingInvitation';
  static const String cannotInviteOwnNumber = 'cannotInviteOwnNumber';
  static const String invalidMobileNumber = 'invalidMobileNumber';

  static const String selectRole = 'selectRole';
  static const String businessNameLength = 'businessNameLength';

  static const String enterAmountAndCategory = 'enterAmountAndCategory';
  static const String amountExceedsMax = 'amountExceedsMax';
  static const String userNotLoggedIn = 'userNotLoggedIn';
  static const String futureDatesNotAllowed = 'futureDatesNotAllowed';
  static const String couldNotInitializeSpeech = 'couldNotInitializeSpeech';
  static const String couldNotUnderstand = 'couldNotUnderstand';
  static const String couldNotProcessVoice = 'couldNotProcessVoice';
  static const String cameraAccessFailed = 'cameraAccessFailed';
  static const String couldNotReadAmount = 'couldNotReadAmount';
  static const String couldNotReadBill = 'couldNotReadBill';
  static const String noReceiptFound = 'noReceiptFound';
  static const String selectCategoryRequired = 'selectCategoryRequired';

  static const String nameMinLength = 'nameMinLength';
  static const String nameMaxLength = 'nameMaxLength';
  static const String amountRequired = 'amountRequired';
  static const String invalidAmount = 'invalidAmount';
  static const String couldNotSave = 'couldNotSave';
  static const String failedToCreateCustomer = 'failedToCreateCustomer';
  static const String failedToRecordCredit = 'failedToRecordCredit';
  static const String failedToRecordRepayment = 'failedToRecordRepayment';
  static const String failedToDeleteCustomer = 'failedToDeleteCustomer';

  static const String nameLength2to100 = 'nameLength2to100';
  static const String targetDateFuture = 'targetDateFuture';
  static const String invalidTargetAmount = 'invalidTargetAmount';
  static const String noActiveProfile = 'noActiveProfile';
  static const String amountRequiredGeneric = 'amountRequiredGeneric';
  static const String invalidAmountGeneric = 'invalidAmountGeneric';
  static const String amountExceedsRemaining = 'amountExceedsRemaining';

  static const String couldNotOpenWhatsapp = 'couldNotOpenWhatsapp';

  static const String purchaseFailed = 'purchaseFailed';
  static const String verificationFailed = 'verificationFailed';

  static const String descriptionRequired = 'descriptionRequired';
  static const String watchAdToCreateInvoice = 'watchAdToCreateInvoice';
  static const String watchAdToExport = 'watchAdToExport';
  static const String activeProfileNotFound = 'activeProfileNotFound';
}
