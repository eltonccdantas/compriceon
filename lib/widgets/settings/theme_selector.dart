import 'package:flutter/material.dart';

import '../../core/constants.dart';

class ThemeSelector extends StatelessWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode) setThemeMode;

  const ThemeSelector({
    super.key,
    required this.themeMode,
    required this.setThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background =
        isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);
    final textColor = isDark ? Colors.white : Colors.black;
    final isDarkMode = themeMode == ThemeMode.dark;

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.light_mode_rounded,
            size: 22,
            color: isDarkMode ? textColor.withAlpha(77) : textColor,
          ),
          const SizedBox(width: 12),
          Switch.adaptive(
            value: isDarkMode,
            activeTrackColor: kBlue,
            onChanged: (value) =>
                setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.dark_mode_rounded,
            size: 22,
            color: isDarkMode ? textColor : textColor.withAlpha(77),
          ),
        ],
      ),
    );
  }
}
