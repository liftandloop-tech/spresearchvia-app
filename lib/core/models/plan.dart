class Plan {
  final String id;
  final String name;
  final double amount;
  final String validity;
  final double cgstPercent;
  final double sgstPercent;
  final String? description;
  final int? validityDays;
  final DateTime? expiryDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? purchaseDate;
  final List<String>? features;
  final bool isActive;
  final bool isExpired;
  final bool isFailed;

  Plan({
    required this.id,
    required this.name,
    required this.amount,
    required this.validity,
    this.cgstPercent = 9.0,
    this.sgstPercent = 9.0,
    this.description,
    this.validityDays,
    this.expiryDate,
    this.startDate,
    this.endDate,
    this.purchaseDate,
    this.features,
    this.isActive = false,
    this.isExpired = false,
    this.isFailed = false,
  });

  double get cgstAmount => (amount * cgstPercent) / 100;
  double get sgstAmount => (amount * sgstPercent) / 100;
  double get totalAmount => amount + cgstAmount + sgstAmount;

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? json['packageName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      validity: json['validity'] ?? '',
      cgstPercent: (json['cgstPercent'] ?? 9.0).toDouble(),
      sgstPercent: (json['sgstPercent'] ?? 9.0).toDouble(),
      description: json['description'],
      validityDays: json['validityDays'],
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'].toString())
          : null,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString())
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'].toString())
          : null,
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.tryParse(json['purchaseDate'].toString())
          : null,
      features: json['features'] != null
          ? List<String>.from(json['features'])
          : null,
      isActive: json['isActive'] ?? false,
      isExpired: json['isExpired'] ?? false,
      isFailed: json['isFailed'] ?? false,
    );
  }

  static List<Plan> getMockPlans() {
    return [
      Plan(
        id: 'annual',
        name: 'Annual Plan',
        amount: 5000,
        validity: '1 Year Access – Renew Annually',
      ),
      Plan(
        id: 'lifetime',
        name: 'One-Time Plan',
        amount: 10000,
        validity: 'Lifetime Access – Pay Once',
      ),
    ];
  }
}
