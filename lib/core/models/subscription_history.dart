enum SubscriptionStatus { active, expired, failed, success, pending }

class SubscriptionHistory {
  final String id;
  final String paymentDate;
  final String amountPaid;
  final String validityDays;
  final String expiryDate;
  final SubscriptionStatus headerStatus;
  final SubscriptionStatus footerStatus;

  SubscriptionHistory({
    required this.id,
    required this.paymentDate,
    required this.amountPaid,
    required this.validityDays,
    required this.expiryDate,
    required this.headerStatus,
    required this.footerStatus,
  });

  factory SubscriptionHistory.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString().toLowerCase() ?? 'active';
    SubscriptionStatus headerStatus = SubscriptionStatus.active;
    if (status == 'expired') {
      headerStatus = SubscriptionStatus.expired;
    } else if (status == 'failed') {
      headerStatus = SubscriptionStatus.failed;
    }

    final startDate = json['startDate'] != null
        ? DateTime.tryParse(json['startDate'].toString())
        : json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString())
        : DateTime.now();

    final endDate = json['endDate'] != null
        ? DateTime.tryParse(json['endDate'].toString())
        : null;

    String paymentDate = 'N/A';
    if (startDate != null) {
      paymentDate =
          '${_monthName(startDate.month)} ${startDate.day}, ${startDate.year}';
    }

    String expiryDate = 'N/A';
    if (endDate != null) {
      expiryDate =
          '${_monthName(endDate.month)} ${endDate.day}, ${endDate.year}';
    }

    final validity = json['validity'] ?? 0;
    String validityDays = '$validity days';

    double amount = 0.0;
    if (json['amount'] != null) {
      amount = (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount'].toString()) ?? 0.0;
    } else if (json['paymentData'] != null &&
        json['paymentData']['amount'] != null) {
      amount = (json['paymentData']['amount'] is num)
          ? (json['paymentData']['amount'] as num).toDouble()
          : double.tryParse(json['paymentData']['amount'].toString()) ?? 0.0;
    } else {
      amount = validity * 365.0;
    }

    String amountPaid = amount > 0 ? '₹${amount.toStringAsFixed(2)}' : 'N/A';

    return SubscriptionHistory(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      paymentDate: paymentDate,
      amountPaid: amountPaid,
      validityDays: validityDays,
      expiryDate: expiryDate,
      headerStatus: headerStatus,
      footerStatus: SubscriptionStatus.success,
    );
  }
  static String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}
