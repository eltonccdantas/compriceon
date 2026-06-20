import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/localization.dart';
import '../models/comparison_result.dart';

class ResultCard extends StatelessWidget {
  final ComparisonResult result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final strings = LocaleScope.of(context).strings;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    final rows = <Widget>[];
    for (int i = 0; i < result.unitPrices.length; i++) {
      if (result.unitPrices[i] == null) continue;
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 8));
      rows.add(
        _PriceRow(
          label: strings.productLabel(i),
          unitPrice: result.unitPrices[i]!,
          isWinner: i == result.winner,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (result.winner == -1)
            _TieRow(strings: strings)
          else
            _WinnerRow(
              winnerLabel: strings.productLabel(result.winner),
              savingPercent: result.savingPercent,
              strings: strings,
            ),
          const SizedBox(height: 16),
          ...rows,
        ],
      ),
    );
  }
}

class _WinnerRow extends StatelessWidget {
  final String winnerLabel;
  final double savingPercent;
  final AppStrings strings;

  const _WinnerRow({
    required this.winnerLabel,
    required this.savingPercent,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: kGreen.withAlpha(31),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.emoji_events_rounded,
            color: kGreen,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                winnerLabel,
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                strings.cheaperPerUnit(savingPercent.toStringAsFixed(1)),
                style: const TextStyle(
                  color: kGreen,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: kGreen.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${savingPercent.toStringAsFixed(0)}%',
            style: const TextStyle(
              color: kGreen,
              fontWeight: FontWeight.w800,
              fontSize: 22,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _TieRow extends StatelessWidget {
  final AppStrings strings;
  const _TieRow({required this.strings});

  @override
  Widget build(BuildContext context) {
    final textPrimary = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF8E8E93).withAlpha(31),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.balance_rounded,
            color: Color(0xFF8E8E93),
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.tie,
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              strings.identicalPrice,
              style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double unitPrice;
  final bool isWinner;

  const _PriceRow({
    required this.label,
    required this.unitPrice,
    required this.isWinner,
  });

  static String _format(double value) {
    if (value >= 1) return value.toStringAsFixed(2);
    if (value >= 0.001) return value.toStringAsFixed(4);
    return value.toStringAsFixed(6);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isWinner
        ? kGreen.withAlpha(20)
        : (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7));

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          if (isWinner) ...[
            const Icon(Icons.check_circle_rounded, color: kGreen, size: 16),
            const SizedBox(width: 7),
          ] else
            const SizedBox(width: 23),
          Text(
            label,
            style: TextStyle(
              color: isWinner
                  ? kGreen
                  : (isDark ? Colors.white70 : Colors.black54),
              fontWeight: isWinner ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            'R\$ ${_format(unitPrice)}/un',
            style: TextStyle(
              color: isWinner
                  ? kGreen
                  : (isDark ? Colors.white54 : Colors.black38),
              fontWeight: isWinner ? FontWeight.w700 : FontWeight.w400,
              fontSize: 14,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
