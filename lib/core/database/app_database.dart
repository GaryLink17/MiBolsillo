// Archivo: lib/core/database/app_database.dart
//
// Punto de entrada de la base local. Permite inyectar una conexión para las
// pruebas o preparar un archivo persistente en el directorio privado de la app.

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Registro de una descarga conjunta completa de cuentas y metas por usuario.
///
/// Al integrar la descarga, esta fila solo debe guardarse en la misma
/// transacción que los datos completos. Su ausencia significa «no descargado».
class BalanceSnapshotMetadata extends Table {
  TextColumn get userId => text()();

  /// Momento en que la app completó la descarga de la captura.
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId};
}

/// Cuentas incluidas en la última captura completa de cada usuario.
///
/// El orden se conserva según la respuesta de la captura. El saldo está en
/// centavos y puede ser negativo. Todavía no se escriben datos reales aquí.
class CachedAccounts extends Table {
  TextColumn get userId => text()();
  TextColumn get accountId => text()();
  TextColumn get name => text()();
  TextColumn get kind => text()();
  IntColumn get balanceCents => integer()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {userId, accountId};
}

/// Metas de una captura conjunta; todos los importes están en centavos.
class CachedGoals extends Table {
  TextColumn get userId => text()();
  TextColumn get goalId => text()();
  TextColumn get name => text()();
  IntColumn get targetCents => integer()();
  IntColumn get savedCents => integer()();

  /// Fecha civil ISO (`aaaa-mm-dd`), sin conversión de zona horaria.
  TextColumn get targetDate => text().nullable()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {userId, goalId};
}

/// Categorías descargadas, incluidos los nombres de icono y tono del servidor.
class CachedCategories extends Table {
  TextColumn get userId => text()();
  TextColumn get categoryId => text()();
  TextColumn get name => text()();
  TextColumn get kind => text()();
  TextColumn get tone => text()();
  TextColumn get icon => text()();
  BoolColumn get isArchived => boolean()();

  @override
  Set<Column> get primaryKey => {userId, categoryId};
}

/// Historial descargado; no representa operaciones pendientes de envío.
///
/// No se exigen claves foráneas hacia las listas activas: una cuenta, meta o
/// categoría archivada puede seguir apareciendo en el historial.
class CachedMovements extends Table {
  TextColumn get userId => text()();
  TextColumn get movementId => text()();
  TextColumn get type => text()();
  IntColumn get amountCents => integer()();

  /// Fecha civil ISO (`aaaa-mm-dd`), sin hora ni zona horaria.
  TextColumn get occurredOn => text()();
  TextColumn get accountId => text()();
  TextColumn get accountName => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get goalId => text().nullable()();
  TextColumn get goalName => text().nullable()();
  TextColumn get note => text().nullable()();

  /// Orden entregado por la descarga, incluidos empates de fecha.
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {userId, movementId};
}

/// Descargas completas de conjuntos independientes de la captura de saldos.
///
/// La fila se escribirá solo después de guardar el conjunto completo; todavía
/// no existe código de descarga ni de paginación.
class CachedDatasetMetadata extends Table {
  TextColumn get userId => text()();
  TextColumn get dataset => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId, dataset};
}

@DriftDatabase(
  tables: [
    BalanceSnapshotMetadata,
    CachedAccounts,
    CachedGoals,
    CachedCategories,
    CachedMovements,
    CachedDatasetMetadata,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Prepara el archivo persistente; Drift lo abre al ejecutar una consulta.
  /// La app todavía no crea esta instancia ni muestra datos locales.
  AppDatabase.persistent()
    : super(
        driftDatabase(
          name: 'mi_bolsillo',
          native: const DriftNativeOptions(
            databaseDirectory: getApplicationSupportDirectory,
          ),
        ),
      );

  @override
  int get schemaVersion => 1;
}
