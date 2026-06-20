import 'package:flutter/material.dart';

import '../../core/localization.dart';

class LanguageSelector extends StatelessWidget {
  final AppLocale locale;
  final void Function(AppLocale) setLocale;

  const LanguageSelector({
    super.key,
    required this.locale,
    required this.setLocale,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background =
        isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);
    final selectedBackground = isDark ? const Color(0xFF48484A) : Colors.white;
    final selectionShadow = isDark
        ? Colors.black.withAlpha(77)
        : Colors.black.withAlpha(26);

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          _SegmentBtn(
            leading: const Text('🇧🇷', style: TextStyle(fontSize: 15)),
            label: 'Português',
            selected: locale == AppLocale.ptBR,
            selectedBackground: selectedBackground,
            selectionShadow: selectionShadow,
            onTap: () => setLocale(AppLocale.ptBR),
          ),
          _SegmentBtn(
            leading: const Text('🇺🇸', style: TextStyle(fontSize: 15)),
            label: 'English',
            selected: locale == AppLocale.enUS,
            selectedBackground: selectedBackground,
            selectionShadow: selectionShadow,
            onTap: () => setLocale(AppLocale.enUS),
          ),
        ],
      ),
    );
  }
}

class _SegmentBtn extends StatelessWidget {
  final Widget leading;
  final String label;
  final bool selected;
  final Color selectedBackground;
  final Color selectionShadow;
  final VoidCallback onTap;

  const _SegmentBtn({
    required this.leading,
    required this.label,
    required this.selected,
    required this.selectedBackground,
    required this.selectionShadow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: selected ? selectedBackground : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: selectionShadow,
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leading,
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
