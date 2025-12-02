import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class TermsSection extends StatelessWidget {
  final bool agreedToTerms;
  final bool authorizedPayment;
  final ValueChanged<bool> onTermsChanged;
  final ValueChanged<bool> onAuthorizationChanged;

  const TermsSection({
    super.key,
    required this.agreedToTerms,
    required this.authorizedPayment,
    required this.onTermsChanged,
    required this.onAuthorizationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCheckboxRow(
          value: agreedToTerms,
          onChanged: (value) => onTermsChanged(value ?? false),
          label: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildCheckboxRow(
          value: authorizedPayment,
          onChanged: (value) => onAuthorizationChanged(value ?? false),
          label: const Text(
            'I authorize SPResearchVia to debit my account for this subscription',
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxRow({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required Widget label,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Padding(padding: const EdgeInsets.only(top: 12), child: label),
        ),
      ],
    );
  }
}
