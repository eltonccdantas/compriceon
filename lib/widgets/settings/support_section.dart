import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization.dart';

class SupportSection extends StatefulWidget {
  const SupportSection({super.key});

  @override
  State<SupportSection> createState() => _SupportSectionState();
}

class _SupportSectionState extends State<SupportSection> {
  static const _pixKey = '3a2b8066-7987-4e10-b0da-8ccc4c9da565';
  static const _pink = Color(0xFFEC4899);

  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final strings = LocaleScope.of(context).strings;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = isDark ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: _pink.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _pink.withAlpha(46)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite_rounded, color: _pink, size: 20),
              const SizedBox(width: 10),
              Text(
                strings.supportTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            strings.supportBody,
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: onSurface.withAlpha(179),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            strings.pixLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: onSurface.withAlpha(128),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              if (_copied) return;
              await Clipboard.setData(const ClipboardData(text: _pixKey));
              setState(() => _copied = true);
              await Future<void>.delayed(const Duration(milliseconds: 1500));
              if (mounted) setState(() => _copied = false);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: onSurface.withAlpha(13),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: onSurface.withAlpha(26)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _pixKey,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                        color: onSurface.withAlpha(217),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.6, end: 1.0)
                            .animate(animation),
                        child: child,
                      ),
                    ),
                    child: _copied
                        ? const Icon(
                            Icons.check_rounded,
                            key: ValueKey('check'),
                            size: 16,
                            color: Color(0xFF34C759),
                          )
                        : Icon(
                            Icons.copy_rounded,
                            key: const ValueKey('copy'),
                            size: 16,
                            color: onSurface.withAlpha(102),
                          ),
                  ),
                ],
              ),
            ),
          ),
          if (_copied) ...[
            const SizedBox(height: 6),
            Center(
              child: Text(
                strings.copied,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF34C759),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
