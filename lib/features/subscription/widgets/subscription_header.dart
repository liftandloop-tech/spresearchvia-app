import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class SubscriptionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showSecurityBadge;

  const SubscriptionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showSecurityBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        if (showSecurityBadge) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, color: AppTheme.primaryGreen, size: 16),
              const SizedBox(width: 4),
              const Text(
                'SSL Secured & PCI-DSS Compliant',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
