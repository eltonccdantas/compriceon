import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final bool isDark;
  final String subtitle;
  final VoidCallback onSettingsTap;

  const AppHeader({
    super.key,
    required this.isDark,
    required this.subtitle,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compriceon',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: onSettingsTap,
            icon: Icon(
              Icons.tune_rounded,
              color: isDark
                  ? Colors.white.withAlpha(115)
                  : Colors.black.withAlpha(115),
              size: 24,
            ),
            padding: const EdgeInsets.only(top: 18),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
