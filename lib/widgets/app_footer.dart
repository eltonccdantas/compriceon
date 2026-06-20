import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatefulWidget {
  const AppFooter({super.key});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _version = info.version);
  }

  Future<void> _openWebsite() async {
    final uri = Uri.parse('https://eltondantas.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          GestureDetector(
            onTap: _openWebsite,
            child: const Text(
              'eltondantas.com',
              style: TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (_version.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'v$_version',
              style: const TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
