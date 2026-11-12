// Archivo: lib/features/balances/data/balance_snapshot_state.dart
//
// Contrato de los estados de la captura conjunta de cuentas y metas.
// Todavía no realiza descargas ni almacena datos en el dispositivo.

import 'package:flutter/foundation.dart' show immutable;

import '../../accounts/data/account.dart';
import '../../goals/data/savings_goal.dart';

/// Una captura completa de cuentas y metas de un mismo usuario.
@immutable
class BalanceSnapshot {
  BalanceSnapshot({
    required this.userId,
    required List<AccountSummary> accounts,
    required List<SavingsGoal> goals,
    required this.updatedAt,
  }) : accounts = List.unmodifiable(accounts),
       goals = List.unmodifiable(goals);

  final String userId;
  final List<AccountSummary> accounts;
  final List<SavingsGoal> goals;

  /// Momento en que la app completó la descarga; no es la fecha del servidor.
  final DateTime updatedAt;
}

/// Estado de una captura. Solo los estados con datos contienen una captura.
@immutable
sealed class BalanceSnapshotState {
  const BalanceSnapshotState();
}

/// Primera carga, cuando aún no se dispone de una captura.
final class BalanceSnapshotLoading extends BalanceSnapshotState {
  const BalanceSnapshotLoading();
}

/// Captura completa disponible tras una actualización exitosa.
final class BalanceSnapshotAvailable extends BalanceSnapshotState {
  const BalanceSnapshotAvailable(this.snapshot);

  final BalanceSnapshot snapshot;
}

/// Última captura completa, cuya actualización no se pudo confirmar.
final class BalanceSnapshotStale extends BalanceSnapshotState {
  const BalanceSnapshotStale(this.snapshot);

  final BalanceSnapshot snapshot;
}

/// No hay captura local y no se pudo obtener una de la nube.
final class BalanceSnapshotUnavailable extends BalanceSnapshotState {
  const BalanceSnapshotUnavailable();
}
