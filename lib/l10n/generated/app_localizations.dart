import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi Bolsillo'**
  String get appTitle;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In es, this message translates to:
  /// **'Omitir'**
  String get skip;

  /// No description provided for @soon.
  ///
  /// In es, this message translates to:
  /// **'Pronto'**
  String get soon;

  /// No description provided for @nextStep.
  ///
  /// In es, this message translates to:
  /// **'Próximo paso'**
  String get nextStep;

  /// No description provided for @settingsTooltip.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTooltip;

  /// No description provided for @newMovementTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo movimiento'**
  String get newMovementTitle;

  /// No description provided for @cloudNotConfigured.
  ///
  /// In es, this message translates to:
  /// **'La nube no está configurada en esta versión.'**
  String get cloudNotConfigured;

  /// No description provided for @sessionExpired.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión expiró. Vuelve a entrar.'**
  String get sessionExpired;

  /// No description provided for @routeNotFound.
  ///
  /// In es, this message translates to:
  /// **'No encontramos esa pantalla: {uri}'**
  String routeNotFound(String uri);

  /// No description provided for @accountFallback.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get accountFallback;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tu dinero, claro y en orden.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomePointAllTitle.
  ///
  /// In es, this message translates to:
  /// **'Todo en un solo lugar'**
  String get welcomePointAllTitle;

  /// No description provided for @welcomePointAllDescription.
  ///
  /// In es, this message translates to:
  /// **'Tus cuentas, tus movimientos y tus metas de ahorro.'**
  String get welcomePointAllDescription;

  /// No description provided for @welcomePointSpendingTitle.
  ///
  /// In es, this message translates to:
  /// **'Entiende en qué gastas'**
  String get welcomePointSpendingTitle;

  /// No description provided for @welcomePointSpendingDescription.
  ///
  /// In es, this message translates to:
  /// **'Categorías claras para saber dónde puedes ajustar.'**
  String get welcomePointSpendingDescription;

  /// No description provided for @welcomePointPrivateTitle.
  ///
  /// In es, this message translates to:
  /// **'Privado y tuyo'**
  String get welcomePointPrivateTitle;

  /// No description provided for @welcomePointPrivateDescription.
  ///
  /// In es, this message translates to:
  /// **'Tus datos quedan en tu cuenta y solo tú los ves.'**
  String get welcomePointPrivateDescription;

  /// No description provided for @welcomeStart.
  ///
  /// In es, this message translates to:
  /// **'Comenzar'**
  String get welcomeStart;

  /// No description provided for @welcomeHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'Ya tengo cuenta'**
  String get welcomeHaveAccount;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In es, this message translates to:
  /// **'Todo tu dinero, en un solo lugar'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Description.
  ///
  /// In es, this message translates to:
  /// **'Consulta tu balance, tus cuentas y tus metas de ahorro de forma clara y sin complicaciones.'**
  String get onboardingPage1Description;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In es, this message translates to:
  /// **'Registra en segundos'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Description.
  ///
  /// In es, this message translates to:
  /// **'Toca el botón + para anotar un gasto, un ingreso o un ahorro. Solo eliges el monto, la cuenta y la categoría.'**
  String get onboardingPage2Description;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In es, this message translates to:
  /// **'Entiende en qué gastas'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Description.
  ///
  /// In es, this message translates to:
  /// **'Revisa tus gastos por categoría y descubre dónde puedes ajustar para llegar más lejos.'**
  String get onboardingPage3Description;

  /// No description provided for @onboardingPage4Title.
  ///
  /// In es, this message translates to:
  /// **'Ahorra con propósito'**
  String get onboardingPage4Title;

  /// No description provided for @onboardingPage4Description.
  ///
  /// In es, this message translates to:
  /// **'Crea metas como tus vacaciones o un fondo de emergencia y mira cómo avanzas cada mes.'**
  String get onboardingPage4Description;

  /// No description provided for @onboardingStart.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get onboardingStart;

  /// No description provided for @onboardingNext.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get onboardingNext;

  /// No description provided for @onboardingStep.
  ///
  /// In es, this message translates to:
  /// **'Paso {current} de {total}'**
  String onboardingStep(int current, int total);

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido de nuevo'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Entra para tener tus cuentas y movimientos al día.'**
  String get loginSubtitle;

  /// No description provided for @loginNoAccount.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta?'**
  String get loginNoAccount;

  /// No description provided for @loginCreateOne.
  ///
  /// In es, this message translates to:
  /// **'Crear una'**
  String get loginCreateOne;

  /// No description provided for @emailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In es, this message translates to:
  /// **'tu@correo.com'**
  String get emailHint;

  /// No description provided for @emailRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu correo.'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In es, this message translates to:
  /// **'Escribe un correo válido.'**
  String get emailInvalid;

  /// No description provided for @passwordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordLabel;

  /// No description provided for @passwordRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu contraseña.'**
  String get passwordRequired;

  /// No description provided for @passwordCreateRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe una contraseña.'**
  String get passwordCreateRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In es, this message translates to:
  /// **'Usa al menos 6 caracteres.'**
  String get passwordTooShort;

  /// No description provided for @passwordHelper.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get passwordHelper;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Repite la contraseña'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden.'**
  String get passwordsDoNotMatch;

  /// No description provided for @showPassword.
  ///
  /// In es, this message translates to:
  /// **'Mostrar'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In es, this message translates to:
  /// **'Ocultar'**
  String get hidePassword;

  /// No description provided for @loginSubmit.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get loginSubmit;

  /// No description provided for @registerTitle.
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tus datos quedan privados y sincronizados en tu cuenta.'**
  String get registerSubtitle;

  /// No description provided for @registerHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta?'**
  String get registerHaveAccount;

  /// No description provided for @registerLogin.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get registerLogin;

  /// No description provided for @nameLabel.
  ///
  /// In es, this message translates to:
  /// **'Tu nombre'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In es, this message translates to:
  /// **'Cómo quieres que te llamemos'**
  String get nameHint;

  /// No description provided for @nameRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu nombre.'**
  String get nameRequired;

  /// No description provided for @registerSubmit.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get registerSubmit;

  /// No description provided for @registerTerms.
  ///
  /// In es, this message translates to:
  /// **'Al crear tu cuenta aceptas que tus datos financieros se guarden de forma privada en tu espacio.'**
  String get registerTerms;

  /// No description provided for @confirmEmailTitle.
  ///
  /// In es, this message translates to:
  /// **'Revisa tu correo'**
  String get confirmEmailTitle;

  /// No description provided for @confirmEmailMessage.
  ///
  /// In es, this message translates to:
  /// **'Te enviamos un enlace para confirmar tu cuenta. Ábrelo y luego entra desde la pantalla de acceso.'**
  String get confirmEmailMessage;

  /// No description provided for @understood.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get understood;

  /// No description provided for @accountReady.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta está lista. ¡Bienvenido!'**
  String get accountReady;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña incorrectos.'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailNotConfirmed.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu correo antes de entrar.'**
  String get authEmailNotConfirmed;

  /// No description provided for @authAlreadyRegistered.
  ///
  /// In es, this message translates to:
  /// **'Ese correo ya tiene una cuenta.'**
  String get authAlreadyRegistered;

  /// No description provided for @authWeakPassword.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 6 caracteres.'**
  String get authWeakPassword;

  /// No description provided for @authInvalidEmail.
  ///
  /// In es, this message translates to:
  /// **'Escribe un correo válido.'**
  String get authInvalidEmail;

  /// No description provided for @authSignupDisabled.
  ///
  /// In es, this message translates to:
  /// **'El registro está desactivado por ahora.'**
  String get authSignupDisabled;

  /// No description provided for @authRateLimited.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos. Espera un momento e intenta de nuevo.'**
  String get authRateLimited;

  /// No description provided for @authNetwork.
  ///
  /// In es, this message translates to:
  /// **'No pudimos conectar. Revisa tu internet e intenta de nuevo.'**
  String get authNetwork;

  /// No description provided for @authSignOutFailed.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cerrar la sesión. Intenta de nuevo.'**
  String get authSignOutFailed;

  /// No description provided for @authUnknown.
  ///
  /// In es, this message translates to:
  /// **'No pudimos completar la operación. Intenta de nuevo.'**
  String get authUnknown;

  /// No description provided for @signOutSuccess.
  ///
  /// In es, this message translates to:
  /// **'Sesión cerrada. Tus datos siguen en tu cuenta.'**
  String get signOutSuccess;

  /// No description provided for @homeBalanceTotal.
  ///
  /// In es, this message translates to:
  /// **'Balance total'**
  String get homeBalanceTotal;

  /// No description provided for @homeIncome.
  ///
  /// In es, this message translates to:
  /// **'Ingresos'**
  String get homeIncome;

  /// No description provided for @homeExpenses.
  ///
  /// In es, this message translates to:
  /// **'Gastos'**
  String get homeExpenses;

  /// No description provided for @homeTotalsError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar los totales del mes.'**
  String get homeTotalsError;

  /// No description provided for @homeBalanceSavingsError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos sumar tus ahorros al balance.'**
  String get homeBalanceSavingsError;

  /// No description provided for @homeMyAccounts.
  ///
  /// In es, this message translates to:
  /// **'Mis cuentas'**
  String get homeMyAccounts;

  /// No description provided for @homeNoAccountsTitle.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes cuentas'**
  String get homeNoAccountsTitle;

  /// No description provided for @homeNoAccountsMessage.
  ///
  /// In es, this message translates to:
  /// **'Configura tu saldo inicial para ver cuánto dinero tienes hoy en cada cuenta.'**
  String get homeNoAccountsMessage;

  /// No description provided for @homeConfigureInitialBalance.
  ///
  /// In es, this message translates to:
  /// **'Configurar saldo inicial'**
  String get homeConfigureInitialBalance;

  /// No description provided for @homeRecentMovements.
  ///
  /// In es, this message translates to:
  /// **'Movimientos recientes'**
  String get homeRecentMovements;

  /// No description provided for @homeSeeAll.
  ///
  /// In es, this message translates to:
  /// **'Ver todos'**
  String get homeSeeAll;

  /// No description provided for @homeNoMovementsTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin movimientos todavía'**
  String get homeNoMovementsTitle;

  /// No description provided for @homeNoMovementsMessage.
  ///
  /// In es, this message translates to:
  /// **'Cuando registres un gasto, un ingreso o un ahorro, aparecerá aquí.'**
  String get homeNoMovementsMessage;

  /// No description provided for @homeMonthSelector.
  ///
  /// In es, this message translates to:
  /// **'El selector de mes'**
  String get homeMonthSelector;

  /// No description provided for @homeComingSoon.
  ///
  /// In es, this message translates to:
  /// **'{feature} llega en el próximo paso.'**
  String homeComingSoon(String feature);

  /// No description provided for @movementsTitle.
  ///
  /// In es, this message translates to:
  /// **'Movimientos'**
  String get movementsTitle;

  /// No description provided for @movementsEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin movimientos todavía'**
  String get movementsEmptyTitle;

  /// No description provided for @movementsEmptyMessage.
  ///
  /// In es, this message translates to:
  /// **'Registra tu primer gasto, ingreso o ahorro para empezar a ver cómo se mueve tu dinero.'**
  String get movementsEmptyMessage;

  /// No description provided for @movementsRegisterFirst.
  ///
  /// In es, this message translates to:
  /// **'Registrar el primero'**
  String get movementsRegisterFirst;

  /// No description provided for @today.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In es, this message translates to:
  /// **'Ayer'**
  String get yesterday;

  /// No description provided for @movementExpense.
  ///
  /// In es, this message translates to:
  /// **'Gasto'**
  String get movementExpense;

  /// No description provided for @movementIncome.
  ///
  /// In es, this message translates to:
  /// **'Ingreso'**
  String get movementIncome;

  /// No description provided for @movementSavings.
  ///
  /// In es, this message translates to:
  /// **'Ahorro'**
  String get movementSavings;

  /// No description provided for @amountLabel.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get amountLabel;

  /// No description provided for @amountHint.
  ///
  /// In es, this message translates to:
  /// **'0.00'**
  String get amountHint;

  /// No description provided for @amountRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe el monto.'**
  String get amountRequired;

  /// No description provided for @amountInvalid.
  ///
  /// In es, this message translates to:
  /// **'Escribe un monto válido.'**
  String get amountInvalid;

  /// No description provided for @amountPositive.
  ///
  /// In es, this message translates to:
  /// **'El monto debe ser mayor que cero.'**
  String get amountPositive;

  /// No description provided for @amountTooLarge.
  ///
  /// In es, this message translates to:
  /// **'Ese monto es demasiado grande.'**
  String get amountTooLarge;

  /// No description provided for @accountQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿De qué cuenta?'**
  String get accountQuestion;

  /// No description provided for @firstSetInitialBalance.
  ///
  /// In es, this message translates to:
  /// **'Primero configura tu saldo inicial'**
  String get firstSetInitialBalance;

  /// No description provided for @needAccountMessage.
  ///
  /// In es, this message translates to:
  /// **'Necesitas al menos una cuenta para registrar movimientos.'**
  String get needAccountMessage;

  /// No description provided for @categoryOptional.
  ///
  /// In es, this message translates to:
  /// **'Categoría (opcional)'**
  String get categoryOptional;

  /// No description provided for @noCategory.
  ///
  /// In es, this message translates to:
  /// **'Sin categoría'**
  String get noCategory;

  /// No description provided for @goalQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿A qué meta ahorras?'**
  String get goalQuestion;

  /// No description provided for @goalRequired.
  ///
  /// In es, this message translates to:
  /// **'Elige la meta a la que vas a ahorrar.'**
  String get goalRequired;

  /// No description provided for @savingsNoGoalsTitle.
  ///
  /// In es, this message translates to:
  /// **'Primero crea una meta'**
  String get savingsNoGoalsTitle;

  /// No description provided for @savingsNoGoalsMessage.
  ///
  /// In es, this message translates to:
  /// **'Necesitas una meta para separar dinero y ver tu progreso.'**
  String get savingsNoGoalsMessage;

  /// No description provided for @savingsHint.
  ///
  /// In es, this message translates to:
  /// **'El ahorro se descuenta de la cuenta y suma a tu meta.'**
  String get savingsHint;

  /// No description provided for @dateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get dateLabel;

  /// No description provided for @datePickerHelp.
  ///
  /// In es, this message translates to:
  /// **'Fecha del movimiento'**
  String get datePickerHelp;

  /// No description provided for @noteLabel.
  ///
  /// In es, this message translates to:
  /// **'Nota (opcional)'**
  String get noteLabel;

  /// No description provided for @noteHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. almuerzo con el equipo'**
  String get noteHint;

  /// No description provided for @saveExpense.
  ///
  /// In es, this message translates to:
  /// **'Guardar gasto'**
  String get saveExpense;

  /// No description provided for @saveIncome.
  ///
  /// In es, this message translates to:
  /// **'Guardar ingreso'**
  String get saveIncome;

  /// No description provided for @saveSaving.
  ///
  /// In es, this message translates to:
  /// **'Guardar ahorro'**
  String get saveSaving;

  /// No description provided for @expenseSaved.
  ///
  /// In es, this message translates to:
  /// **'Gasto registrado.'**
  String get expenseSaved;

  /// No description provided for @incomeSaved.
  ///
  /// In es, this message translates to:
  /// **'Ingreso registrado.'**
  String get incomeSaved;

  /// No description provided for @savingSaved.
  ///
  /// In es, this message translates to:
  /// **'Ahorro registrado.'**
  String get savingSaved;

  /// No description provided for @accountExpenseRequired.
  ///
  /// In es, this message translates to:
  /// **'Elige la cuenta de donde sale el dinero.'**
  String get accountExpenseRequired;

  /// No description provided for @accountIncomeRequired.
  ///
  /// In es, this message translates to:
  /// **'Elige la cuenta donde entra el dinero.'**
  String get accountIncomeRequired;

  /// No description provided for @accountSavingsRequired.
  ///
  /// In es, this message translates to:
  /// **'Elige la cuenta de donde sale el ahorro.'**
  String get accountSavingsRequired;

  /// No description provided for @initialBalanceTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Con cuánto empiezas?'**
  String get initialBalanceTitle;

  /// No description provided for @initialBalanceSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Escribe lo que tienes hoy en cada cuenta. Si alguna no la usas, desactívala.'**
  String get initialBalanceSubtitle;

  /// No description provided for @initialBalanceTotal.
  ///
  /// In es, this message translates to:
  /// **'Tu saldo total'**
  String get initialBalanceTotal;

  /// No description provided for @initialBalanceUse.
  ///
  /// In es, this message translates to:
  /// **'Usar'**
  String get initialBalanceUse;

  /// No description provided for @initialBalanceAmountLabel.
  ///
  /// In es, this message translates to:
  /// **'Saldo actual'**
  String get initialBalanceAmountLabel;

  /// No description provided for @initialBalanceAmountHint.
  ///
  /// In es, this message translates to:
  /// **'0.00'**
  String get initialBalanceAmountHint;

  /// No description provided for @initialBalanceInvalidAmount.
  ///
  /// In es, this message translates to:
  /// **'Escribe un monto válido.'**
  String get initialBalanceInvalidAmount;

  /// No description provided for @initialBalanceNegative.
  ///
  /// In es, this message translates to:
  /// **'El monto no puede ser negativo.'**
  String get initialBalanceNegative;

  /// No description provided for @initialBalanceTooLarge.
  ///
  /// In es, this message translates to:
  /// **'Ese monto es demasiado grande.'**
  String get initialBalanceTooLarge;

  /// No description provided for @initialBalanceActivateOne.
  ///
  /// In es, this message translates to:
  /// **'Activa al menos una cuenta.'**
  String get initialBalanceActivateOne;

  /// No description provided for @initialBalanceReady.
  ///
  /// In es, this message translates to:
  /// **'Tus cuentas están listas.'**
  String get initialBalanceReady;

  /// No description provided for @initialBalanceStart.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get initialBalanceStart;

  /// No description provided for @initialBalanceLater.
  ///
  /// In es, this message translates to:
  /// **'Lo hago después'**
  String get initialBalanceLater;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @settingsAccount.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta'**
  String get settingsAccount;

  /// No description provided for @settingsProfile.
  ///
  /// In es, this message translates to:
  /// **'Tu perfil'**
  String get settingsProfile;

  /// No description provided for @settingsActiveSession.
  ///
  /// In es, this message translates to:
  /// **'Sesión activa'**
  String get settingsActiveSession;

  /// No description provided for @settingsSignInToSync.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para sincronizar'**
  String get settingsSignInToSync;

  /// No description provided for @settingsGeneral.
  ///
  /// In es, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsAppearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get settingsAppearance;

  /// No description provided for @themeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get themeSystem;

  /// No description provided for @settingsLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get settingsLanguage;

  /// No description provided for @languageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get languageSystem;

  /// No description provided for @settingsCurrency.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get settingsCurrency;

  /// No description provided for @settingsCurrencyValue.
  ///
  /// In es, this message translates to:
  /// **'RD\$ · Peso dominicano'**
  String get settingsCurrencyValue;

  /// No description provided for @settingsCurrencyMessage.
  ///
  /// In es, this message translates to:
  /// **'Por ahora trabajamos solo con pesos dominicanos.'**
  String get settingsCurrencyMessage;

  /// No description provided for @settingsManageCategories.
  ///
  /// In es, this message translates to:
  /// **'Administrar categorías'**
  String get settingsManageCategories;

  /// No description provided for @settingsDailyReminders.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios diarios'**
  String get settingsDailyReminders;

  /// No description provided for @settingsSecurityData.
  ///
  /// In es, this message translates to:
  /// **'Seguridad y datos'**
  String get settingsSecurityData;

  /// No description provided for @settingsBiometric.
  ///
  /// In es, this message translates to:
  /// **'Bloqueo con huella o rostro'**
  String get settingsBiometric;

  /// No description provided for @settingsChangePassword.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get settingsChangePassword;

  /// No description provided for @settingsExportData.
  ///
  /// In es, this message translates to:
  /// **'Exportar mis datos'**
  String get settingsExportData;

  /// No description provided for @settingsHelp.
  ///
  /// In es, this message translates to:
  /// **'Ayuda'**
  String get settingsHelp;

  /// No description provided for @settingsReplayTutorial.
  ///
  /// In es, this message translates to:
  /// **'Ver tutorial de nuevo'**
  String get settingsReplayTutorial;

  /// No description provided for @settingsAbout.
  ///
  /// In es, this message translates to:
  /// **'Acerca de Mi Bolsillo'**
  String get settingsAbout;

  /// No description provided for @settingsSignOut.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get settingsSignOut;

  /// No description provided for @settingsSignIn.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get settingsSignIn;

  /// No description provided for @settingsVersion.
  ///
  /// In es, this message translates to:
  /// **'Mi Bolsillo · versión 1.0.0'**
  String get settingsVersion;

  /// No description provided for @aboutContent.
  ///
  /// In es, this message translates to:
  /// **'Versión 1.0.0\n\nTus finanzas, claras y en orden. Hecho para acompañarte en cada gasto, ingreso y ahorro.'**
  String get aboutContent;

  /// No description provided for @placeholderTitle.
  ///
  /// In es, this message translates to:
  /// **'Estamos construyendo esta sección'**
  String get placeholderTitle;

  /// No description provided for @accountsTitle.
  ///
  /// In es, this message translates to:
  /// **'Cuentas y metas'**
  String get accountsTitle;

  /// No description provided for @accountsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Revisa tus saldos y avanza en tus metas de ahorro.'**
  String get accountsSubtitle;

  /// No description provided for @categoriesTitle.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categoriesTitle;

  /// No description provided for @categoriesPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Descubre en qué se va tu dinero con gráficos claros y comparaciones por semana, mes o año.'**
  String get categoriesPlaceholder;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navMovements.
  ///
  /// In es, this message translates to:
  /// **'Movimientos'**
  String get navMovements;

  /// No description provided for @navAccounts.
  ///
  /// In es, this message translates to:
  /// **'Cuentas'**
  String get navAccounts;

  /// No description provided for @navCategories.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get navCategories;

  /// No description provided for @navNewMovement.
  ///
  /// In es, this message translates to:
  /// **'Nuevo movimiento'**
  String get navNewMovement;

  /// No description provided for @accountCash.
  ///
  /// In es, this message translates to:
  /// **'Efectivo'**
  String get accountCash;

  /// No description provided for @accountBank.
  ///
  /// In es, this message translates to:
  /// **'Banco'**
  String get accountBank;

  /// No description provided for @accountSavings.
  ///
  /// In es, this message translates to:
  /// **'Ahorros'**
  String get accountSavings;

  /// No description provided for @accountCard.
  ///
  /// In es, this message translates to:
  /// **'Tarjeta'**
  String get accountCard;

  /// No description provided for @accountOther.
  ///
  /// In es, this message translates to:
  /// **'Otra cuenta'**
  String get accountOther;

  /// No description provided for @categoryFood.
  ///
  /// In es, this message translates to:
  /// **'Comida'**
  String get categoryFood;

  /// No description provided for @categoryTransport.
  ///
  /// In es, this message translates to:
  /// **'Transporte'**
  String get categoryTransport;

  /// No description provided for @categoryHome.
  ///
  /// In es, this message translates to:
  /// **'Hogar'**
  String get categoryHome;

  /// No description provided for @categoryLeisure.
  ///
  /// In es, this message translates to:
  /// **'Ocio'**
  String get categoryLeisure;

  /// No description provided for @categoryHealth.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get categoryHealth;

  /// No description provided for @categoryOther.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get categoryOther;

  /// No description provided for @categorySalary.
  ///
  /// In es, this message translates to:
  /// **'Salario'**
  String get categorySalary;

  /// No description provided for @accountsLoadError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tus cuentas. Revisa tu conexión.'**
  String get accountsLoadError;

  /// No description provided for @accountsSaveError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos guardar tus cuentas. Revisa tu conexión.'**
  String get accountsSaveError;

  /// No description provided for @accountsPermissionError.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta no tiene permisos para guardar. Vuelve a entrar.'**
  String get accountsPermissionError;

  /// No description provided for @movementsLoadError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tus movimientos. Revisa tu conexión.'**
  String get movementsLoadError;

  /// No description provided for @movementsSaveError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos guardar el movimiento. Revisa tu conexión.'**
  String get movementsSaveError;

  /// No description provided for @movementsTotalsError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar los totales del mes. Revisa tu conexión.'**
  String get movementsTotalsError;

  /// No description provided for @movementsPermissionError.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta no tiene permisos para guardar movimientos.'**
  String get movementsPermissionError;

  /// No description provided for @movementsRelatedMissing.
  ///
  /// In es, this message translates to:
  /// **'La cuenta, la categoría o la meta ya no existe.'**
  String get movementsRelatedMissing;

  /// No description provided for @movementsInvalidData.
  ///
  /// In es, this message translates to:
  /// **'Revisa los datos del movimiento e intenta de nuevo.'**
  String get movementsInvalidData;

  /// No description provided for @movementsSaveUnknown.
  ///
  /// In es, this message translates to:
  /// **'No pudimos guardar el movimiento. Intenta de nuevo.'**
  String get movementsSaveUnknown;

  /// No description provided for @categoriesLoadError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tus categorías. Revisa tu conexión.'**
  String get categoriesLoadError;

  /// No description provided for @goalsSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Metas de ahorro'**
  String get goalsSectionTitle;

  /// No description provided for @goalsEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes metas'**
  String get goalsEmptyTitle;

  /// No description provided for @goalsEmptyMessage.
  ///
  /// In es, this message translates to:
  /// **'Crea una meta y separa dinero para lo que quieres lograr.'**
  String get goalsEmptyMessage;

  /// No description provided for @goalsCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear meta'**
  String get goalsCreate;

  /// No description provided for @goalsLoadError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tus metas. Revisa tu conexión.'**
  String get goalsLoadError;

  /// No description provided for @goalsSaveError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos guardar la meta. Revisa tu conexión.'**
  String get goalsSaveError;

  /// No description provided for @goalsPermissionError.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta no tiene permisos para guardar metas.'**
  String get goalsPermissionError;

  /// No description provided for @goalsInvalidData.
  ///
  /// In es, this message translates to:
  /// **'Revisa los datos de la meta e intenta de nuevo.'**
  String get goalsInvalidData;

  /// No description provided for @goalsSaveUnknown.
  ///
  /// In es, this message translates to:
  /// **'No pudimos guardar la meta. Intenta de nuevo.'**
  String get goalsSaveUnknown;

  /// No description provided for @goalNewTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva meta'**
  String get goalNewTitle;

  /// No description provided for @goalNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la meta'**
  String get goalNameLabel;

  /// No description provided for @goalNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Vacaciones, fondo de emergencia'**
  String get goalNameHint;

  /// No description provided for @goalNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe un nombre para la meta.'**
  String get goalNameRequired;

  /// No description provided for @goalNameTooLong.
  ///
  /// In es, this message translates to:
  /// **'Usa 60 caracteres o menos.'**
  String get goalNameTooLong;

  /// No description provided for @goalTargetLabel.
  ///
  /// In es, this message translates to:
  /// **'Monto objetivo'**
  String get goalTargetLabel;

  /// No description provided for @goalTargetRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe el monto objetivo.'**
  String get goalTargetRequired;

  /// No description provided for @goalTargetInvalid.
  ///
  /// In es, this message translates to:
  /// **'Escribe un monto válido.'**
  String get goalTargetInvalid;

  /// No description provided for @goalTargetPositive.
  ///
  /// In es, this message translates to:
  /// **'El monto debe ser mayor que cero.'**
  String get goalTargetPositive;

  /// No description provided for @goalTargetTooLarge.
  ///
  /// In es, this message translates to:
  /// **'Ese monto es demasiado grande.'**
  String get goalTargetTooLarge;

  /// No description provided for @goalDateOptional.
  ///
  /// In es, this message translates to:
  /// **'Fecha objetivo (opcional)'**
  String get goalDateOptional;

  /// No description provided for @goalNoDate.
  ///
  /// In es, this message translates to:
  /// **'Sin fecha'**
  String get goalNoDate;

  /// No description provided for @goalClearDate.
  ///
  /// In es, this message translates to:
  /// **'Quitar fecha'**
  String get goalClearDate;

  /// No description provided for @goalDatePickerHelp.
  ///
  /// In es, this message translates to:
  /// **'Fecha objetivo'**
  String get goalDatePickerHelp;

  /// No description provided for @goalDatePast.
  ///
  /// In es, this message translates to:
  /// **'Elige una fecha de hoy en adelante.'**
  String get goalDatePast;

  /// No description provided for @goalSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar meta'**
  String get goalSave;

  /// No description provided for @goalSaved.
  ///
  /// In es, this message translates to:
  /// **'Meta creada.'**
  String get goalSaved;

  /// No description provided for @goalSavedOf.
  ///
  /// In es, this message translates to:
  /// **'Ahorrado: {saved} de {target}'**
  String goalSavedOf(String saved, String target);

  /// No description provided for @goalRemaining.
  ///
  /// In es, this message translates to:
  /// **'Faltan {amount}'**
  String goalRemaining(String amount);

  /// No description provided for @goalTargetFor.
  ///
  /// In es, this message translates to:
  /// **'Para {date}'**
  String goalTargetFor(String date);

  /// No description provided for @goalCompleted.
  ///
  /// In es, this message translates to:
  /// **'Meta lograda'**
  String get goalCompleted;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
