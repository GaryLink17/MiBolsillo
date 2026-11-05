import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'app_card.dart';
import 'common.dart';
import 'money_text.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.name,
    required this.balance,
    required this.icon,
    this.width = 164,
    this.onTap,
  });

  final String name;
  final double balance;
  final IconData icon;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return SizedBox(
      width: width,
      height: 140,
      child: AppCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: palette.surfaceAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: theme.colorScheme.onSurface),
            ),
            const Spacer(),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 15,
                color: palette.muted,
              ),
            ),
            const SizedBox(height: 2),
            MoneyText(
              balance,
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
              showSymbol: false,
            ),
          ],
        ),
      ),
    );
  }
}

class MovementTile extends StatelessWidget {
  const MovementTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.tone,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final double amount;
  final IconData icon;
  final CategoryTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CategoryAvatar(icon: icon, tone: tone),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: palette.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          MoneyText(
            amount,
            style: theme.textTheme.titleMedium?.copyWith(
              color: amount > 0 ? palette.income : theme.colorScheme.onSurface,
            ),
            showSign: true,
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: content,
    );
  }
}
