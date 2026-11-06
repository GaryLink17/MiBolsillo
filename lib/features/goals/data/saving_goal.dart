import 'package:flutter/foundation.dart' show immutable;

@immutable
class SavingsGoal {
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.saved,
    this.targetDate,
  });

  final String id;
  final String name;
  final double targerAmount;
  final double saved;
  final DataTime? targerData;
}
