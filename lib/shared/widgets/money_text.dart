import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_colors.dart';

/// Monto con el símbolo `RD$` y decimales en un tamaño/color secundario,
/// como en el diseño. Se adapta si el espacio es reducido.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.amount, {
    super.key,
    this.style,
    this.showSymbol = true,
    this.showDecimals = false,
    this.showSign = false,
    this.symbolColor,
    this.decimalsColor,
    this.alignment = Alignment.centerLeft,
  });

  final num amount;
  final TextStyle? style;
  final bool showSymbol;
  final bool showDecimals;
  final bool showSign;
  final Color? symbolColor;
  final Color? decimalsColor;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final base = style ?? theme.textTheme.titleLarge!;
    final fontSize = base.fontSize ?? 16;
    final color = base.color ?? theme.colorScheme.onSurface;
    final absolute = amount.abs();
    final formatted = NumberFormat(
      showDecimals ? '#,##0.00' : '#,##0',
      'en_US',
    ).format(absolute);
    final parts = formatted.split('.');
    final sign = amount < 0 ? '-' : (showSign && amount > 0 ? '+' : '');

    final span = TextSpan(
      style: base.copyWith(color: color),
      children: [
        if (sign.isNotEmpty)
          TextSpan(
            text: sign,
            style: TextStyle(fontSize: fontSize * 0.78),
          ),
        if (showSymbol)
          TextSpan(
            text: 'RD\$ ',
            style: TextStyle(
              fontSize: fontSize * 0.58,
              fontWeight: FontWeight.w600,
              color: symbolColor ?? palette.muted,
              letterSpacing: 0,
            ),
          ),
        TextSpan(text: parts.first),
        if (showDecimals)
          TextSpan(
            text: '.${parts.length > 1 ? parts.last : '00'}',
            style: TextStyle(
              fontSize: fontSize * 0.55,
              fontWeight: FontWeight.w600,
              color: decimalsColor ?? palette.muted,
            ),
          ),
      ],
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: alignment,
      child: Text.rich(span, maxLines: 1, softWrap: false),
    );
  }
}
