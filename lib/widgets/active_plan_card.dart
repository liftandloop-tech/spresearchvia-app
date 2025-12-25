import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/models/plan.dart';
import '../core/utils/responsive.dart';

class ActivePlanCard extends StatelessWidget {
  const ActivePlanCard({
    super.key,
    required this.plan,
    required this.startDateText,
    required this.expiryDateText,
    required this.perDayCost,
    required this.totalPaid,
    required this.completionPercentage,
    this.onRenew,
    this.onViewInvoice,
    this.tags = const ['Index Option', 'Trader'],
  });

  final Plan plan;
  final String startDateText;
  final String expiryDateText;
  final int perDayCost;
  final double totalPaid;
  final int completionPercentage;
  final VoidCallback? onRenew;
  final VoidCallback? onViewInvoice;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: responsive.wp(1.5)),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(responsive.radius(16)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: responsive.wp(1.5)),
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(responsive.radius(16)),
            border: Border.all(color: AppTheme.borderGrey, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowMedium,
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: responsive.padding(all: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan.name.isNotEmpty
                            ? plan.name
                            : 'Index Option – Splendid Plan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: responsive.sp(18),
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlueDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: responsive.padding(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen,
                        borderRadius: BorderRadius.circular(
                          responsive.radius(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: responsive.wp(1.5),
                            height: responsive.wp(1.5),
                            decoration: const BoxDecoration(
                              color: AppTheme.textWhite,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: responsive.wp(1.2)),
                          Text(
                            'Active',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: responsive.sp(12),
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.hp(1.5)),
                Wrap(
                  spacing: responsive.wp(2),
                  children: tags
                      .map((tag) => _buildTag(tag, responsive))
                      .toList(),
                ),
                SizedBox(height: responsive.hp(2.5)),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoColumn(
                        'Start Date',
                        startDateText,
                        responsive,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoColumn(
                        'Expiry Date',
                        expiryDateText,
                        responsive,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.hp(2.5)),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: responsive.padding(all: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.profileCardBackground,
                          borderRadius: BorderRadius.circular(
                            responsive.radius(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Per Day Cost',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: responsive.sp(12),
                                color: AppTheme.textGrey,
                              ),
                            ),
                            SizedBox(height: responsive.hp(0.5)),
                            Text(
                              '₹$perDayCost',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: responsive.sp(20),
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryBlueDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: responsive.wp(3)),
                    Expanded(
                      child: Container(
                        padding: responsive.padding(all: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            responsive.radius(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Paid',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: responsive.sp(12),
                                color: AppTheme.textGrey,
                              ),
                            ),
                            SizedBox(height: responsive.hp(0.5)),
                            Text(
                              '₹${totalPaid.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: responsive.sp(20),
                                fontWeight: FontWeight.w600,
                                color: AppTheme.successGreen,
                              ),
                            ),
                            SizedBox(height: responsive.hp(0.25)),
                            Text(
                              'Excl. GST',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: responsive.sp(10),
                                color: AppTheme.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.hp(2.5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Plan Duration',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: responsive.sp(12),
                        color: AppTheme.textGrey,
                      ),
                    ),
                    Text(
                      '$completionPercentage% Complete',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: responsive.sp(12),
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlueDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.hp(1)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(responsive.radius(4)),
                  child: LinearProgressIndicator(
                    value: completionPercentage / 100,
                    minHeight: responsive.hp(1),
                    backgroundColor: AppTheme.borderGrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.successGreen,
                    ),
                  ),
                ),
                SizedBox(height: responsive.hp(2.5)),
                Row(
                  children: [
                    if (onRenew != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onRenew,
                          icon: Icon(Icons.refresh, size: responsive.sp(18)),
                          label: const Text('Renew Plan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successGreen,
                            foregroundColor: AppTheme.textWhite,
                            padding: responsive.padding(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                responsive.radius(8),
                              ),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    if (onRenew != null && onViewInvoice != null)
                      SizedBox(width: responsive.wp(3)),
                    if (onViewInvoice != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onViewInvoice,
                          icon: Icon(
                            Icons.receipt_long,
                            size: responsive.sp(18),
                          ),
                          label: const Text('View Invoice'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryBlueDark,
                            side: const BorderSide(
                              color: AppTheme.primaryBlue,
                              width: 1.5,
                            ),
                            padding: responsive.padding(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                responsive.radius(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Responsive responsive) {
    return Container(
      padding: responsive.padding(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.infoBackground,
        borderRadius: BorderRadius.circular(responsive.radius(6)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: responsive.sp(12),
          fontWeight: FontWeight.w500,
          color: AppTheme.primaryBlueDark,
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: responsive.sp(12),
            color: AppTheme.textGrey,
          ),
        ),
        SizedBox(height: responsive.hp(0.5)),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: responsive.sp(14),
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlueDark,
          ),
        ),
      ],
    );
  }
}
