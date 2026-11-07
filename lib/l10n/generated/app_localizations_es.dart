// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mi Bolsillo';

  @override
  String get retry => 'Reintentar';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Volver';

  @override
  String get skip => 'Omitir';

  @override
  String get soon => 'Pronto';

  @override
  String get nextStep => 'Próximo paso';

  @override
  String get settingsTooltip => 'Ajustes';

  @override
  String get newMovementTitle => 'Nuevo movimiento';

  @override
  String get cloudNotConfigured =>
      'La nube no está configurada en esta versión.';

  @override
  String get sessionExpired => 'Tu sesión expiró. Vuelve a entrar.';

  @override
  String routeNotFound(String uri) {
    return 'No encontramos esa pantalla: $uri';
  }

  @override
  String get accountFallback => 'Cuenta';

  @override
  String get welcomeSubtitle => 'Tu dinero, claro y en orden.';

  @override
  String get welcomePointAllTitle => 'Todo en un solo lugar';

  @override
  String get welcomePointAllDescription =>
      'Tus cuentas, tus movimientos y tus metas de ahorro.';

  @override
  String get welcomePointSpendingTitle => 'Entiende en qué gastas';

  @override
  String get welcomePointSpendingDescription =>
      'Categorías claras para saber dónde puedes ajustar.';

  @override
  String get welcomePointPrivateTitle => 'Privado y tuyo';

  @override
  String get welcomePointPrivateDescription =>
      'Tus datos quedan en tu cuenta y solo tú los ves.';

  @override
  String get welcomeStart => 'Comenzar';

  @override
  String get welcomeHaveAccount => 'Ya tengo cuenta';

  @override
  String get onboardingPage1Title => 'Todo tu dinero, en un solo lugar';

  @override
  String get onboardingPage1Description =>
      'Consulta tu balance, tus cuentas y tus metas de ahorro de forma clara y sin complicaciones.';

  @override
  String get onboardingPage2Title => 'Registra en segundos';

  @override
  String get onboardingPage2Description =>
      'Toca el botón + para anotar un gasto, un ingreso o un ahorro. Solo eliges el monto, la cuenta y la categoría.';

  @override
  String get onboardingPage3Title => 'Entiende en qué gastas';

  @override
  String get onboardingPage3Description =>
      'Revisa tus gastos por categoría y descubre dónde puedes ajustar para llegar más lejos.';

  @override
  String get onboardingPage4Title => 'Ahorra con propósito';

  @override
  String get onboardingPage4Description =>
      'Crea metas como tus vacaciones o un fondo de emergencia y mira cómo avanzas cada mes.';

  @override
  String get onboardingStart => 'Empezar';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String onboardingStep(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get loginTitle => 'Bienvenido de nuevo';

  @override
  String get loginSubtitle =>
      'Entra para tener tus cuentas y movimientos al día.';

  @override
  String get loginNoAccount => '¿No tienes cuenta?';

  @override
  String get loginCreateOne => 'Crear una';

  @override
  String get emailLabel => 'Correo';

  @override
  String get emailHint => 'tu@correo.com';

  @override
  String get emailRequired => 'Escribe tu correo.';

  @override
  String get emailInvalid => 'Escribe un correo válido.';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordRequired => 'Escribe tu contraseña.';

  @override
  String get passwordCreateRequired => 'Escribe una contraseña.';

  @override
  String get passwordTooShort => 'Usa al menos 6 caracteres.';

  @override
  String get passwordHelper => 'Mínimo 6 caracteres';

  @override
  String get confirmPasswordLabel => 'Repite la contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden.';

  @override
  String get showPassword => 'Mostrar';

  @override
  String get hidePassword => 'Ocultar';

  @override
  String get loginSubmit => 'Entrar';

  @override
  String get registerTitle => 'Crea tu cuenta';

  @override
  String get registerSubtitle =>
      'Tus datos quedan privados y sincronizados en tu cuenta.';

  @override
  String get registerHaveAccount => '¿Ya tienes cuenta?';

  @override
  String get registerLogin => 'Entrar';

  @override
  String get nameLabel => 'Tu nombre';

  @override
  String get nameHint => 'Cómo quieres que te llamemos';

  @override
  String get nameRequired => 'Escribe tu nombre.';

  @override
  String get registerSubmit => 'Crear cuenta';

  @override
  String get registerTerms =>
      'Al crear tu cuenta aceptas que tus datos financieros se guarden de forma privada en tu espacio.';

  @override
  String get confirmEmailTitle => 'Revisa tu correo';

  @override
  String get confirmEmailMessage =>
      'Te enviamos un enlace para confirmar tu cuenta. Ábrelo y luego entra desde la pantalla de acceso.';

  @override
  String get understood => 'Entendido';

  @override
  String get accountReady => 'Tu cuenta está lista. ¡Bienvenido!';

  @override
  String get authInvalidCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get authEmailNotConfirmed => 'Confirma tu correo antes de entrar.';

  @override
  String get authAlreadyRegistered => 'Ese correo ya tiene una cuenta.';

  @override
  String get authWeakPassword =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get authInvalidEmail => 'Escribe un correo válido.';

  @override
  String get authSignupDisabled => 'El registro está desactivado por ahora.';

  @override
  String get authRateLimited =>
      'Demasiados intentos. Espera un momento e intenta de nuevo.';

  @override
  String get authNetwork =>
      'No pudimos conectar. Revisa tu internet e intenta de nuevo.';

  @override
  String get authSignOutFailed =>
      'No pudimos cerrar la sesión. Intenta de nuevo.';

  @override
  String get authUnknown =>
      'No pudimos completar la operación. Intenta de nuevo.';

  @override
  String get signOutSuccess => 'Sesión cerrada. Tus datos siguen en tu cuenta.';

  @override
  String get homeBalanceTotal => 'Balance total';

  @override
  String get homeIncome => 'Ingresos';

  @override
  String get homeExpenses => 'Gastos';

  @override
  String get homeTotalsError => 'No pudimos cargar los totales del mes.';

  @override
  String get homeBalanceSavingsError =>
      'No pudimos sumar tus ahorros al balance.';

  @override
  String get homeMyAccounts => 'Mis cuentas';

  @override
  String get homeNoAccountsTitle => 'Aún no tienes cuentas';

  @override
  String get homeNoAccountsMessage =>
      'Configura tu saldo inicial para ver cuánto dinero tienes hoy en cada cuenta.';

  @override
  String get homeConfigureInitialBalance => 'Configurar saldo inicial';

  @override
  String get homeRecentMovements => 'Movimientos recientes';

  @override
  String get homeSeeAll => 'Ver todos';

  @override
  String get homeNoMovementsTitle => 'Sin movimientos todavía';

  @override
  String get homeNoMovementsMessage =>
      'Cuando registres un gasto, un ingreso o un ahorro, aparecerá aquí.';

  @override
  String get homeMonthSelector => 'El selector de mes';

  @override
  String homeComingSoon(String feature) {
    return '$feature llega en el próximo paso.';
  }

  @override
  String get movementsTitle => 'Movimientos';

  @override
  String get movementsEmptyTitle => 'Sin movimientos todavía';

  @override
  String get movementsEmptyMessage =>
      'Registra tu primer gasto, ingreso o ahorro para empezar a ver cómo se mueve tu dinero.';

  @override
  String get movementsRegisterFirst => 'Registrar el primero';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get movementExpense => 'Gasto';

  @override
  String get movementIncome => 'Ingreso';

  @override
  String get movementSavings => 'Ahorro';

  @override
  String get amountLabel => 'Monto';

  @override
  String get amountHint => '0.00';

  @override
  String get amountRequired => 'Escribe el monto.';

  @override
  String get amountInvalid => 'Escribe un monto válido.';

  @override
  String get amountPositive => 'El monto debe ser mayor que cero.';

  @override
  String get amountTooLarge => 'Ese monto es demasiado grande.';

  @override
  String get accountQuestion => '¿De qué cuenta?';

  @override
  String get firstSetInitialBalance => 'Primero configura tu saldo inicial';

  @override
  String get needAccountMessage =>
      'Necesitas al menos una cuenta para registrar movimientos.';

  @override
  String get categoryOptional => 'Categoría (opcional)';

  @override
  String get noCategory => 'Sin categoría';

  @override
  String get goalQuestion => '¿A qué meta ahorras?';

  @override
  String get goalRequired => 'Elige la meta a la que vas a ahorrar.';

  @override
  String get savingsNoGoalsTitle => 'Primero crea una meta';

  @override
  String get savingsNoGoalsMessage =>
      'Necesitas una meta para separar dinero y ver tu progreso.';

  @override
  String get savingsHint =>
      'El ahorro se descuenta de la cuenta y suma a tu meta.';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get datePickerHelp => 'Fecha del movimiento';

  @override
  String get noteLabel => 'Nota (opcional)';

  @override
  String get noteHint => 'Ej. almuerzo con el equipo';

  @override
  String get saveExpense => 'Guardar gasto';

  @override
  String get saveIncome => 'Guardar ingreso';

  @override
  String get saveSaving => 'Guardar ahorro';

  @override
  String get expenseSaved => 'Gasto registrado.';

  @override
  String get incomeSaved => 'Ingreso registrado.';

  @override
  String get savingSaved => 'Ahorro registrado.';

  @override
  String get accountExpenseRequired =>
      'Elige la cuenta de donde sale el dinero.';

  @override
  String get accountIncomeRequired => 'Elige la cuenta donde entra el dinero.';

  @override
  String get accountSavingsRequired =>
      'Elige la cuenta de donde sale el ahorro.';

  @override
  String get initialBalanceTitle => '¿Con cuánto empiezas?';

  @override
  String get initialBalanceSubtitle =>
      'Escribe lo que tienes hoy en cada cuenta. Si alguna no la usas, desactívala.';

  @override
  String get initialBalanceTotal => 'Tu saldo total';

  @override
  String get initialBalanceUse => 'Usar';

  @override
  String get initialBalanceAmountLabel => 'Saldo actual';

  @override
  String get initialBalanceAmountHint => '0.00';

  @override
  String get initialBalanceInvalidAmount => 'Escribe un monto válido.';

  @override
  String get initialBalanceNegative => 'El monto no puede ser negativo.';

  @override
  String get initialBalanceTooLarge => 'Ese monto es demasiado grande.';

  @override
  String get initialBalanceActivateOne => 'Activa al menos una cuenta.';

  @override
  String get initialBalanceReady => 'Tus cuentas están listas.';

  @override
  String get initialBalanceStart => 'Empezar';

  @override
  String get initialBalanceLater => 'Lo hago después';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsAccount => 'Tu cuenta';

  @override
  String get settingsProfile => 'Tu perfil';

  @override
  String get settingsActiveSession => 'Sesión activa';

  @override
  String get settingsSignInToSync => 'Inicia sesión para sincronizar';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get settingsCurrency => 'Moneda';

  @override
  String get settingsCurrencyValue => 'RD\$ · Peso dominicano';

  @override
  String get settingsCurrencyMessage =>
      'Por ahora trabajamos solo con pesos dominicanos.';

  @override
  String get settingsManageCategories => 'Administrar categorías';

  @override
  String get settingsDailyReminders => 'Recordatorios diarios';

  @override
  String get settingsSecurityData => 'Seguridad y datos';

  @override
  String get settingsBiometric => 'Bloqueo con huella o rostro';

  @override
  String get settingsChangePassword => 'Cambiar contraseña';

  @override
  String get settingsExportData => 'Exportar mis datos';

  @override
  String get settingsHelp => 'Ayuda';

  @override
  String get settingsReplayTutorial => 'Ver tutorial de nuevo';

  @override
  String get settingsAbout => 'Acerca de Mi Bolsillo';

  @override
  String get settingsSignOut => 'Cerrar sesión';

  @override
  String get settingsSignIn => 'Iniciar sesión';

  @override
  String get settingsVersion => 'Mi Bolsillo · versión 1.0.0';

  @override
  String get aboutContent =>
      'Versión 1.0.0\n\nTus finanzas, claras y en orden. Hecho para acompañarte en cada gasto, ingreso y ahorro.';

  @override
  String get placeholderTitle => 'Estamos construyendo esta sección';

  @override
  String get accountsTitle => 'Cuentas y metas';

  @override
  String get accountsSubtitle =>
      'Revisa tus saldos y avanza en tus metas de ahorro.';

  @override
  String get categoriesTitle => 'Categorías';

  @override
  String get categoriesPlaceholder =>
      'Descubre en qué se va tu dinero con gráficos claros y comparaciones por semana, mes o año.';

  @override
  String get navHome => 'Inicio';

  @override
  String get navMovements => 'Movimientos';

  @override
  String get navAccounts => 'Cuentas';

  @override
  String get navCategories => 'Categorías';

  @override
  String get navNewMovement => 'Nuevo movimiento';

  @override
  String get accountCash => 'Efectivo';

  @override
  String get accountBank => 'Banco';

  @override
  String get accountSavings => 'Ahorros';

  @override
  String get accountCard => 'Tarjeta';

  @override
  String get accountOther => 'Otra cuenta';

  @override
  String get categoryFood => 'Comida';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryHome => 'Hogar';

  @override
  String get categoryLeisure => 'Ocio';

  @override
  String get categoryHealth => 'Salud';

  @override
  String get categoryOther => 'Otros';

  @override
  String get categorySalary => 'Salario';

  @override
  String get accountsLoadError =>
      'No pudimos cargar tus cuentas. Revisa tu conexión.';

  @override
  String get accountsSaveError =>
      'No pudimos guardar tus cuentas. Revisa tu conexión.';

  @override
  String get accountsPermissionError =>
      'Tu cuenta no tiene permisos para guardar. Vuelve a entrar.';

  @override
  String get movementsLoadError =>
      'No pudimos cargar tus movimientos. Revisa tu conexión.';

  @override
  String get movementsSaveError =>
      'No pudimos guardar el movimiento. Revisa tu conexión.';

  @override
  String get movementsTotalsError =>
      'No pudimos cargar los totales del mes. Revisa tu conexión.';

  @override
  String get movementsPermissionError =>
      'Tu cuenta no tiene permisos para guardar movimientos.';

  @override
  String get movementsRelatedMissing =>
      'La cuenta, la categoría o la meta ya no existe.';

  @override
  String get movementsInvalidData =>
      'Revisa los datos del movimiento e intenta de nuevo.';

  @override
  String get movementsSaveUnknown =>
      'No pudimos guardar el movimiento. Intenta de nuevo.';

  @override
  String get categoriesLoadError =>
      'No pudimos cargar tus categorías. Revisa tu conexión.';

  @override
  String get goalsSectionTitle => 'Metas de ahorro';

  @override
  String get goalsEmptyTitle => 'Aún no tienes metas';

  @override
  String get goalsEmptyMessage =>
      'Crea una meta y separa dinero para lo que quieres lograr.';

  @override
  String get goalsCreate => 'Crear meta';

  @override
  String get goalsLoadError =>
      'No pudimos cargar tus metas. Revisa tu conexión.';

  @override
  String get goalsSaveError =>
      'No pudimos guardar la meta. Revisa tu conexión.';

  @override
  String get goalsPermissionError =>
      'Tu cuenta no tiene permisos para guardar metas.';

  @override
  String get goalsInvalidData =>
      'Revisa los datos de la meta e intenta de nuevo.';

  @override
  String get goalsSaveUnknown =>
      'No pudimos guardar la meta. Intenta de nuevo.';

  @override
  String get goalNewTitle => 'Nueva meta';

  @override
  String get goalNameLabel => 'Nombre de la meta';

  @override
  String get goalNameHint => 'Ej. Vacaciones, fondo de emergencia';

  @override
  String get goalNameRequired => 'Escribe un nombre para la meta.';

  @override
  String get goalNameTooLong => 'Usa 60 caracteres o menos.';

  @override
  String get goalTargetLabel => 'Monto objetivo';

  @override
  String get goalTargetRequired => 'Escribe el monto objetivo.';

  @override
  String get goalTargetInvalid => 'Escribe un monto válido.';

  @override
  String get goalTargetPositive => 'El monto debe ser mayor que cero.';

  @override
  String get goalTargetTooLarge => 'Ese monto es demasiado grande.';

  @override
  String get goalDateOptional => 'Fecha objetivo (opcional)';

  @override
  String get goalNoDate => 'Sin fecha';

  @override
  String get goalClearDate => 'Quitar fecha';

  @override
  String get goalDatePickerHelp => 'Fecha objetivo';

  @override
  String get goalDatePast => 'Elige una fecha de hoy en adelante.';

  @override
  String get goalSave => 'Guardar meta';

  @override
  String get goalSaved => 'Meta creada.';

  @override
  String goalSavedOf(String saved, String target) {
    return 'Ahorrado: $saved de $target';
  }

  @override
  String goalRemaining(String amount) {
    return 'Faltan $amount';
  }

  @override
  String goalTargetFor(String date) {
    return 'Para $date';
  }

  @override
  String get goalCompleted => 'Meta lograda';
}
