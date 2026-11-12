// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mi Bolsillo';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String get soon => 'Soon';

  @override
  String get nextStep => 'Next step';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get newMovementTitle => 'New movement';

  @override
  String get cloudNotConfigured =>
      'The cloud is not configured in this version.';

  @override
  String get sessionExpired => 'Your session expired. Please sign in again.';

  @override
  String routeNotFound(String uri) {
    return 'We couldn\'t find that screen: $uri';
  }

  @override
  String get accountFallback => 'Account';

  @override
  String get welcomeSubtitle => 'Your money, clear and organized.';

  @override
  String get welcomePointAllTitle => 'Everything in one place';

  @override
  String get welcomePointAllDescription =>
      'Your accounts, movements and savings goals.';

  @override
  String get welcomePointSpendingTitle => 'Understand where you spend';

  @override
  String get welcomePointSpendingDescription =>
      'Clear categories so you know where you can adjust.';

  @override
  String get welcomePointPrivateTitle => 'Private and yours';

  @override
  String get welcomePointPrivateDescription =>
      'Your data stays in your account and only you can see it.';

  @override
  String get welcomeStart => 'Get started';

  @override
  String get welcomeHaveAccount => 'I already have an account';

  @override
  String get onboardingPage1Title => 'All your money, in one place';

  @override
  String get onboardingPage1Description =>
      'Check your balance, accounts and savings goals clearly and simply.';

  @override
  String get onboardingPage2Title => 'Record in seconds';

  @override
  String get onboardingPage2Description =>
      'Tap the + button to log an expense, income or saving. Just choose the amount, account and category.';

  @override
  String get onboardingPage3Title => 'Understand where you spend';

  @override
  String get onboardingPage3Description =>
      'Review your expenses by category and find out where you can adjust to go further.';

  @override
  String get onboardingPage4Title => 'Save with purpose';

  @override
  String get onboardingPage4Description =>
      'Create goals like your vacation or an emergency fund and watch your progress every month.';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingNext => 'Next';

  @override
  String onboardingStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle =>
      'Sign in to keep your accounts and movements up to date.';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginCreateOne => 'Create one';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'you@email.com';

  @override
  String get emailRequired => 'Enter your email.';

  @override
  String get emailInvalid => 'Enter a valid email.';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Enter your password.';

  @override
  String get passwordCreateRequired => 'Enter a password.';

  @override
  String get passwordTooShort => 'Use at least 6 characters.';

  @override
  String get passwordHelper => 'At least 6 characters';

  @override
  String get confirmPasswordLabel => 'Repeat password';

  @override
  String get passwordsDoNotMatch => 'Passwords don\'t match.';

  @override
  String get showPassword => 'Show';

  @override
  String get hidePassword => 'Hide';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle =>
      'Your data stays private and synced to your account.';

  @override
  String get registerHaveAccount => 'Already have an account?';

  @override
  String get registerLogin => 'Sign in';

  @override
  String get nameLabel => 'Your name';

  @override
  String get nameHint => 'What should we call you?';

  @override
  String get nameRequired => 'Enter your name.';

  @override
  String get registerSubmit => 'Create account';

  @override
  String get registerTerms =>
      'By creating your account you agree that your financial data will be stored privately in your space.';

  @override
  String get confirmEmailTitle => 'Check your email';

  @override
  String get confirmEmailMessage =>
      'We sent you a link to confirm your account. Open it and then sign in from the login screen.';

  @override
  String get understood => 'Got it';

  @override
  String get accountReady => 'Your account is ready. Welcome!';

  @override
  String get authInvalidCredentials => 'Incorrect email or password.';

  @override
  String get authEmailNotConfirmed => 'Confirm your email before signing in.';

  @override
  String get authAlreadyRegistered => 'That email already has an account.';

  @override
  String get authWeakPassword => 'The password must be at least 6 characters.';

  @override
  String get authInvalidEmail => 'Enter a valid email.';

  @override
  String get authSignupDisabled => 'Registration is disabled for now.';

  @override
  String get authRateLimited =>
      'Too many attempts. Wait a moment and try again.';

  @override
  String get authNetwork =>
      'We couldn\'t connect. Check your internet and try again.';

  @override
  String get authSignOutFailed => 'We couldn\'t sign out. Try again.';

  @override
  String get authUnknown => 'We couldn\'t complete the operation. Try again.';

  @override
  String get signOutSuccess =>
      'Signed out. Your data is still in your account.';

  @override
  String get homeBalanceTotal => 'Total balance';

  @override
  String get homeIncome => 'Income';

  @override
  String get homeExpenses => 'Expenses';

  @override
  String get homeTotalsError => 'We couldn\'t load this month\'s totals.';

  @override
  String get homeBalanceSavingsError =>
      'We couldn\'t add your savings to the balance.';

  @override
  String get homeMyAccounts => 'My accounts';

  @override
  String get homeNoAccountsTitle => 'You don\'t have any accounts yet';

  @override
  String get homeNoAccountsMessage =>
      'Set your initial balance to see how much money you have in each account today.';

  @override
  String get homeConfigureInitialBalance => 'Set initial balance';

  @override
  String get homeRecentMovements => 'Recent movements';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeNoMovementsTitle => 'No movements yet';

  @override
  String get homeNoMovementsMessage =>
      'When you record an expense, income or saving, it will appear here.';

  @override
  String get homeMonthSelector => 'The month selector';

  @override
  String homeComingSoon(String feature) {
    return '$feature is coming in the next step.';
  }

  @override
  String get movementsTitle => 'Movements';

  @override
  String get movementsEmptyTitle => 'No movements yet';

  @override
  String get movementsEmptyMessage =>
      'Record your first expense, income or saving to start seeing how your money moves.';

  @override
  String get movementsRegisterFirst => 'Record the first one';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get movementsSearch => 'Search movements';

  @override
  String get movementsFilters => 'Filters';

  @override
  String get movementsFilterType => 'Type';

  @override
  String get movementsFilterAccount => 'Account';

  @override
  String get movementsFilterCategory => 'Category';

  @override
  String get movementsFilterDate => 'Choose date range';

  @override
  String get movementsFilterAll => 'All';

  @override
  String get movementsClearFilters => 'Clear filters';

  @override
  String get movementsNoResults => 'No results';

  @override
  String get movementsNoResultsMessage =>
      'Try another search or change the filters.';

  @override
  String get movementExpense => 'Expense';

  @override
  String get movementIncome => 'Income';

  @override
  String get movementSavings => 'Saving';

  @override
  String get amountLabel => 'Amount';

  @override
  String get amountHint => '0.00';

  @override
  String get amountRequired => 'Enter the amount.';

  @override
  String get amountInvalid => 'Enter a valid amount.';

  @override
  String get amountPositive => 'The amount must be greater than zero.';

  @override
  String get amountTooLarge => 'That amount is too large.';

  @override
  String get accountQuestion => 'Which account?';

  @override
  String get firstSetInitialBalance => 'First set your initial balance';

  @override
  String get needAccountMessage =>
      'You need at least one account to record movements.';

  @override
  String get categoryOptional => 'Category (optional)';

  @override
  String get noCategory => 'No category';

  @override
  String get goalQuestion => 'Which goal are you saving toward?';

  @override
  String get goalRequired => 'Choose the goal you\'re saving toward.';

  @override
  String get savingsNoGoalsTitle => 'First create a goal';

  @override
  String get savingsNoGoalsMessage =>
      'You need a goal to set money aside and track your progress.';

  @override
  String get savingsHint =>
      'The saving is deducted from the account and added to your goal.';

  @override
  String get dateLabel => 'Date';

  @override
  String get datePickerHelp => 'Movement date';

  @override
  String get noteLabel => 'Note (optional)';

  @override
  String get noteHint => 'E.g. lunch with the team';

  @override
  String get saveExpense => 'Save expense';

  @override
  String get saveIncome => 'Save income';

  @override
  String get saveSaving => 'Save saving';

  @override
  String get expenseSaved => 'Expense recorded.';

  @override
  String get incomeSaved => 'Income recorded.';

  @override
  String get savingSaved => 'Saving recorded.';

  @override
  String get accountExpenseRequired =>
      'Choose the account the money comes from.';

  @override
  String get accountIncomeRequired => 'Choose the account the money goes into.';

  @override
  String get accountSavingsRequired =>
      'Choose the account the saving comes from.';

  @override
  String get initialBalanceTitle => 'How much are you starting with?';

  @override
  String get initialBalanceSubtitle =>
      'Enter what you have today in each account. If you don\'t use one, turn it off.';

  @override
  String get initialBalanceTotal => 'Your total balance';

  @override
  String get initialBalanceUse => 'Use';

  @override
  String get initialBalanceAmountLabel => 'Current balance';

  @override
  String get initialBalanceAmountHint => '0.00';

  @override
  String get initialBalanceInvalidAmount => 'Enter a valid amount.';

  @override
  String get initialBalanceNegative => 'The amount can\'t be negative.';

  @override
  String get initialBalanceTooLarge => 'That amount is too large.';

  @override
  String get initialBalanceActivateOne => 'Turn on at least one account.';

  @override
  String get initialBalanceReady => 'Your accounts are ready.';

  @override
  String get initialBalanceStart => 'Get started';

  @override
  String get initialBalanceLater => 'I\'ll do it later';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccount => 'Your account';

  @override
  String get settingsProfile => 'Your profile';

  @override
  String get settingsActiveSession => 'Active session';

  @override
  String get settingsSignInToSync => 'Sign in to sync';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSystem => 'System';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsCurrencyValue => 'RD\$ · Dominican peso';

  @override
  String get settingsCurrencyMessage =>
      'For now we only work with Dominican pesos.';

  @override
  String get settingsManageCategories => 'Manage categories';

  @override
  String get settingsDailyReminders => 'Daily reminders';

  @override
  String get settingsSecurityData => 'Security and data';

  @override
  String get settingsBiometric => 'Fingerprint or face lock';

  @override
  String get settingsChangePassword => 'Change password';

  @override
  String get settingsExportData => 'Export my data';

  @override
  String get settingsHelp => 'Help';

  @override
  String get settingsReplayTutorial => 'Replay tutorial';

  @override
  String get settingsAbout => 'About Mi Bolsillo';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsSignIn => 'Sign in';

  @override
  String get settingsVersion => 'Mi Bolsillo · version 1.0.0';

  @override
  String get aboutContent =>
      'Version 1.0.0\n\nYour finances, clear and organized. Made to support you through every expense, income and saving.';

  @override
  String get placeholderTitle => 'We\'re building this section';

  @override
  String get accountsTitle => 'Accounts and goals';

  @override
  String get accountsSubtitle =>
      'Check your balances and move forward with your savings goals.';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get categoriesPlaceholder =>
      'Discover where your money goes with clear charts and comparisons by week, month or year.';

  @override
  String get navHome => 'Home';

  @override
  String get navMovements => 'Movements';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get navCategories => 'Categories';

  @override
  String get navNewMovement => 'New movement';

  @override
  String get accountCash => 'Cash';

  @override
  String get accountBank => 'Bank';

  @override
  String get accountSavings => 'Savings';

  @override
  String get accountCard => 'Card';

  @override
  String get accountOther => 'Other account';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryHome => 'Home';

  @override
  String get categoryLeisure => 'Leisure';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryOther => 'Other';

  @override
  String get categorySalary => 'Salary';

  @override
  String get accountsLoadError =>
      'We couldn\'t load your accounts. Check your connection.';

  @override
  String get accountsSaveError =>
      'We couldn\'t save your accounts. Check your connection.';

  @override
  String get accountsPermissionError =>
      'Your account doesn\'t have permission to save. Please sign in again.';

  @override
  String get movementsLoadError =>
      'We couldn\'t load your movements. Check your connection.';

  @override
  String get movementsSaveError =>
      'We couldn\'t save the movement. Check your connection.';

  @override
  String get movementsTotalsError =>
      'We couldn\'t load this month\'s totals. Check your connection.';

  @override
  String get movementsPermissionError =>
      'Your account doesn\'t have permission to save movements.';

  @override
  String get movementsRelatedMissing =>
      'The account, category or goal no longer exists.';

  @override
  String get movementsInvalidData => 'Check the movement data and try again.';

  @override
  String get movementsSaveUnknown =>
      'We couldn\'t save the movement. Try again.';

  @override
  String get categoriesLoadError =>
      'We couldn\'t load your categories. Check your connection.';

  @override
  String get goalsSectionTitle => 'Savings goals';

  @override
  String get goalsEmptyTitle => 'You don\'t have any goals yet';

  @override
  String get goalsEmptyMessage =>
      'Create a goal and set money aside for what you want to achieve.';

  @override
  String get goalsCreate => 'Create goal';

  @override
  String get goalsLoadError =>
      'We couldn\'t load your goals. Check your connection.';

  @override
  String get goalsSaveError =>
      'We couldn\'t save the goal. Check your connection.';

  @override
  String get goalsPermissionError =>
      'Your account doesn\'t have permission to save goals.';

  @override
  String get goalsInvalidData => 'Check the goal data and try again.';

  @override
  String get goalsSaveUnknown => 'We couldn\'t save the goal. Try again.';

  @override
  String get goalNewTitle => 'New goal';

  @override
  String get goalNameLabel => 'Goal name';

  @override
  String get goalNameHint => 'E.g. Vacation, emergency fund';

  @override
  String get goalNameRequired => 'Enter a name for the goal.';

  @override
  String get goalNameTooLong => 'Use 60 characters or fewer.';

  @override
  String get goalTargetLabel => 'Target amount';

  @override
  String get goalTargetRequired => 'Enter the target amount.';

  @override
  String get goalTargetInvalid => 'Enter a valid amount.';

  @override
  String get goalTargetPositive => 'The amount must be greater than zero.';

  @override
  String get goalTargetTooLarge => 'That amount is too large.';

  @override
  String get goalDateOptional => 'Target date (optional)';

  @override
  String get goalNoDate => 'No date';

  @override
  String get goalClearDate => 'Remove date';

  @override
  String get goalDatePickerHelp => 'Target date';

  @override
  String get goalDatePast => 'Choose a date from today onward.';

  @override
  String get goalSave => 'Save goal';

  @override
  String get goalSaved => 'Goal created.';

  @override
  String goalSavedOf(String saved, String target) {
    return 'Saved: $saved of $target';
  }

  @override
  String goalRemaining(String amount) {
    return '$amount to go';
  }

  @override
  String goalTargetFor(String date) {
    return 'For $date';
  }

  @override
  String get goalCompleted => 'Goal reached';
}
