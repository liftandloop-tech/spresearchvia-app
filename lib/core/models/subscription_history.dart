enum SubscriptionStatus { active, expired, failed, success }

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
}
