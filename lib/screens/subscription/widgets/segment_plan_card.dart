import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SegmentPlanCard extends StatelessWidget {
  const SegmentPlanCard({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.perDay,
    required this.benefits,
    required this.isSelected,
    this.badge,
    this.isPopular = false,
    this.onTap,
  });

  final String id;
  final String name, description, amount, perDay;
  final List<String> benefits;
  final bool isSelected;
  final String? badge;
  final bool isPopular;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isHNI = name == 'HNI Custom Plan';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.borderGrey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? AppTheme.primaryGreen.withValues(alpha: 0.05)
              : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPopular
                        ? AppTheme.primaryGreen
                        : AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      if (isHNI) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppTheme.textGrey,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected ? AppTheme.primaryGreen : AppTheme.textGrey,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: AppTheme.textBlack),
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        amount,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      if (isHNI)
                        const Text(
                          '(Excl. GST)',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textGrey,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      perDay.split('\n')[0],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    if (perDay.contains('\n'))
                      Text(
                        perDay.split('\n')[1],
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            for (String benefit in benefits)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.primaryGreen,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        benefit,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
