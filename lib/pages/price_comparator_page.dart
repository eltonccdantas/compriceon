import 'dart:math' show min, max;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/localization.dart';
import '../models/comparison_result.dart';
import '../widgets/app_header.dart';
import '../widgets/compare_button.dart';
import '../widgets/product_card.dart';
import '../widgets/result_card.dart';
import '../widgets/settings/settings_sheet.dart';

class PriceComparatorPage extends StatefulWidget {
  const PriceComparatorPage({super.key});

  @override
  State<PriceComparatorPage> createState() => _PriceComparatorPageState();
}

class _PriceComparatorPageState extends State<PriceComparatorPage>
    with SingleTickerProviderStateMixin {
  final _prices = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final _qtys = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  bool get _canCompare {
    int filled = 0;
    for (int i = 0; i < 3; i++) {
      if (_prices[i].text.trim().isNotEmpty &&
          _qtys[i].text.trim().isNotEmpty) {
        filled++;
      }
    }
    return filled >= 2;
  }

  ComparisonResult? _result;
  late final AnimationController _animationController;

  late final Animation<double> _winnerScale;
  late final Animation<double> _winnerBorder;
  late final Animation<double> _loserOpacity;
  late final Animation<double> _loserScale;
  late final Animation<double> _badgeOpacity;
  late final Animation<double> _badgeScale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _winnerScale = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _winnerBorder = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _loserOpacity = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.05, 0.6, curve: Curves.easeInOutCubic),
      ),
    );
    _loserScale = Tween<double>(begin: 1.0, end: 0.975).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.05, 0.6, curve: Curves.easeInOutCubic),
      ),
    );
    _badgeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.32, 0.72, curve: Curves.easeOut),
      ),
    );
    _badgeScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.32, 0.72, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final controller in _prices) {
      controller.dispose();
    }
    for (final controller in _qtys) {
      controller.dispose();
    }
    super.dispose();
  }

  void _compare() {
    FocusScope.of(context).unfocus();
    HapticFeedback.mediumImpact();

    final unitPrices = List<double?>.filled(3, null);
    for (int i = 0; i < 3; i++) {
      final price = double.tryParse(_prices[i].text.replaceAll(',', '.'));
      final quantity = double.tryParse(_qtys[i].text.replaceAll(',', '.'));
      if (price != null && quantity != null && price > 0 && quantity > 0) {
        unitPrices[i] = price / quantity;
      }
    }

    final filled = unitPrices.whereType<double>().toList();
    if (filled.length < 2) return;

    final minPrice = filled.reduce(min);
    final maxPrice = filled.reduce(max);

    final int winner;
    final double saving;
    if (minPrice == maxPrice) {
      winner = -1;
      saving = 0;
    } else {
      winner = unitPrices.indexOf(minPrice);
      saving = ((maxPrice - minPrice) / maxPrice) * 100;
    }

    setState(() {
      _result = ComparisonResult(
        unitPrices: unitPrices,
        winner: winner,
        savingPercent: saving,
      );
    });
    _animationController.forward(from: 0);
  }

  void _reset() {
    _animationController
        .animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        )
        .then((_) {
          if (!mounted) return;
          setState(() {
            _result = null;
            for (final controller in _prices) {
              controller.clear();
            }
            for (final controller in _qtys) {
              controller.clear();
            }
          });
        });
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = LocaleScope.of(context).strings;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppHeader(
                isDark: isDark,
                subtitle: strings.subtitle,
                onSettingsTap: _openSettings,
              ),
              const SizedBox(height: 24),
              _buildCard(0, strings),
              const SizedBox(height: 12),
              _buildCard(1, strings),
              const SizedBox(height: 12),
              _buildCard(2, strings),
              const SizedBox(height: 20),
              ListenableBuilder(
                listenable: Listenable.merge([..._prices, ..._qtys]),
                builder: (context, _) {
                  final enabled = _result != null || _canCompare;
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    opacity: enabled ? 1.0 : 0.4,
                    child: CompareButton(
                      onPressed: _result != null
                          ? _reset
                          : (_canCompare ? _compare : null),
                      label: _result != null
                          ? strings.compareAgain
                          : strings.compare,
                    ),
                  );
                },
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.08),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: _result != null
                    ? Padding(
                        key: const ValueKey('result'),
                        padding: const EdgeInsets.only(top: 16),
                        child: ResultCard(result: _result!),
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int index, AppStrings strings) {
    final label = strings.productLabel(index);
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        final result = _result;
        final isTie = result?.winner == -1;
        final notIncluded =
            result != null && result.unitPrices[index] == null;

        if (result == null || isTie || notIncluded) {
          return ProductCard(
            label: label,
            priceController: _prices[index],
            qtyController: _qtys[index],
            priceLabel: strings.price,
            qtyLabel: strings.quantity,
            requiredMsg: strings.required_,
            invalidMsg: strings.invalid,
            state: CardState.neutral,
            scale: 1.0,
            opacity: 1.0,
            borderProgress: 0.0,
            badgeOpacity: 0.0,
            badgeScale: 0.0,
            badgeLabel: strings.bestOption,
          );
        }

        final isWinner = result.winner == index;
        return ProductCard(
          label: label,
          priceController: _prices[index],
          qtyController: _qtys[index],
          priceLabel: strings.price,
          qtyLabel: strings.quantity,
          requiredMsg: strings.required_,
          invalidMsg: strings.invalid,
          state: isWinner ? CardState.winner : CardState.loser,
          scale: isWinner ? _winnerScale.value : _loserScale.value,
          opacity: isWinner ? 1.0 : _loserOpacity.value,
          borderProgress: isWinner ? _winnerBorder.value : 0.0,
          badgeOpacity: isWinner ? _badgeOpacity.value : 0.0,
          badgeScale: isWinner ? _badgeScale.value : 0.0,
          badgeLabel: strings.bestOption,
        );
      },
    );
  }
}
