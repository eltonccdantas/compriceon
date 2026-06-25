import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants.dart';

enum CardState { neutral, winner, loser }

class ProductCard extends StatelessWidget {
  final String label;
  final TextEditingController priceController;
  final TextEditingController qtyController;
  final String priceLabel;
  final String qtyLabel;
  final String requiredMsg;
  final String invalidMsg;
  final CardState state;
  final double scale;
  final double opacity;
  final double borderProgress;
  final double badgeOpacity;
  final double badgeScale;
  final String badgeLabel;
  final bool enabled;

  const ProductCard({
    super.key,
    required this.label,
    required this.priceController,
    required this.qtyController,
    required this.priceLabel,
    required this.qtyLabel,
    required this.requiredMsg,
    required this.invalidMsg,
    required this.state,
    required this.scale,
    required this.opacity,
    required this.borderProgress,
    required this.badgeOpacity,
    required this.badgeScale,
    required this.badgeLabel,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBackground = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final glowAlpha = (borderProgress * 45).round();

    final shadows = [
      if (glowAlpha > 0)
        BoxShadow(
          color: kGreen.withAlpha(glowAlpha),
          blurRadius: 24,
          offset: const Offset(0, 6),
        ),
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 38 : 10),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ];

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: borderProgress > 0
                    ? Border.all(
                        color: kGreen.withAlpha((borderProgress * 255).round()),
                        width: 1.5,
                      )
                    : null,
                boxShadow: shadows,
              ),
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardLabel(label: label, state: state, isDark: isDark),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _NumField(
                          controller: priceController,
                          label: priceLabel,
                          hint: '0,00',
                          prefix: 'R\$',
                          requiredMsg: requiredMsg,
                          invalidMsg: invalidMsg,
                          enabled: enabled,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _NumField(
                          controller: qtyController,
                          label: qtyLabel,
                          hint: '1',
                          suffix: 'un',
                          requiredMsg: requiredMsg,
                          invalidMsg: invalidMsg,
                          enabled: enabled,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (badgeOpacity > 0)
              Positioned(
                top: -12,
                right: 16,
                child: Opacity(
                  opacity: badgeOpacity,
                  child: Transform.scale(
                    scale: badgeScale,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: kGreen,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: kGreen.withAlpha(77),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            badgeLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  final String label;
  final CardState state;
  final bool isDark;

  const _CardLabel({
    required this.label,
    required this.state,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isWinner = state == CardState.winner;
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 450),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isWinner
                ? kGreen.withAlpha(31)
                : (isDark
                    ? const Color(0xFF2C2C2E)
                    : const Color(0xFFF2F2F7)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isWinner
                ? Icons.emoji_events_rounded
                : Icons.shopping_bag_outlined,
            color: isWinner ? kGreen : const Color(0xFF8E8E93),
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 450),
          style: TextStyle(
            color: isWinner
                ? kGreen
                : (isDark ? Colors.white : Colors.black),
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: -0.2,
          ),
          child: Text(label),
        ),
      ],
    );
  }
}

class _NumField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? prefix;
  final String? suffix;
  final String requiredMsg;
  final String invalidMsg;
  final bool enabled;

  const _NumField({
    required this.controller,
    required this.label,
    required this.hint,
    this.prefix,
    this.suffix,
    required this.requiredMsg,
    required this.invalidMsg,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7);
    const gray = Color(0xFF8E8E93);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: gray, fontSize: 13),
        hintText: hint,
        hintStyle: TextStyle(color: gray.withAlpha(153)),
        prefixText: prefix != null ? '$prefix ' : null,
        prefixStyle: const TextStyle(color: gray, fontSize: 16),
        suffixText: suffix,
        suffixStyle: const TextStyle(color: gray, fontSize: 13),
        filled: true,
        fillColor: fill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF007AFF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF3B30), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF3B30), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        errorStyle: const TextStyle(
          fontSize: 10,
          height: 0.8,
          color: Color(0xFFFF3B30),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return requiredMsg;
        final number = double.tryParse(value.replaceAll(',', '.'));
        if (number == null || number <= 0) return invalidMsg;
        return null;
      },
    );
  }
}
