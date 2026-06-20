import 'package:flutter/material.dart';

import '../../core/localization.dart';
import 'language_selector.dart';
import 'support_section.dart';
import 'theme_selector.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = LocaleScope.of(context);
    final strings = scope.strings;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final handle = isDark ? const Color(0xFF48484A) : const Color(0xFFD1D1D6);

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: handle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      strings.settings,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  _SectionLabel(label: strings.appearance),
                  const SizedBox(height: 8),
                  ThemeSelector(
                    themeMode: scope.themeMode,
                    setThemeMode: scope.setThemeMode,
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(label: strings.language),
                  const SizedBox(height: 8),
                  LanguageSelector(
                    locale: scope.locale,
                    setLocale: scope.setLocale,
                  ),
                  const SizedBox(height: 24),
                  const SupportSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: isDark
            ? Colors.white.withAlpha(115)
            : Colors.black.withAlpha(115),
      ),
    );
  }
}
